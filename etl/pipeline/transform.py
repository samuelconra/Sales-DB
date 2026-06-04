"""Transform step: derive warehouse rows from extracted source data.

This module is pure (no DB, no I/O) so it is fully unit-testable. It produces
row tuples in the exact column order expected by the loaders.
"""
from __future__ import annotations

import calendar
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta
from decimal import ROUND_HALF_UP, Decimal

_CENTS = Decimal("0.01")

# Column orders -- kept next to the builders that produce them.
DIM_DATE_COLUMNS = (
    "date_key", "full_date", "year", "quarter", "month",
    "month_name", "day", "day_of_week", "is_weekend",
)
DIM_TIME_COLUMNS = ("time_key", "hour", "minute", "second", "time_of_day")
FACT_COLUMNS = (
    "date_key", "time_key", "branch_key", "product_key", "payment_method_key",
    "sale_id", "ticket_number", "quantity", "unit_price",
    "base_price_at_sale", "subtotal", "discount_amount",
)
FACT_PK = ("date_key", "time_key", "branch_key", "product_key", "payment_method_key")


# --- Smart-key helpers -------------------------------------------------------

def date_key(d: date) -> int:
    """YYYYMMDD as an integer (the dim_date smart key)."""
    return d.year * 10000 + d.month * 100 + d.day


def time_key(t: datetime) -> int:
    """HHMMSS as an integer (the dim_time smart key)."""
    return t.hour * 10000 + t.minute * 100 + t.second


def time_of_day(hour: int) -> str:
    if hour < 6:
        return "Night"
    if hour < 12:
        return "Morning"
    if hour < 18:
        return "Afternoon"
    return "Evening"


# --- Dimension builders ------------------------------------------------------

def build_dim_date(min_date: date, max_date: date) -> list:
    """One contiguous row per calendar day, padded to whole years.

    Month and weekday names come from ``calendar`` (English, locale-independent)
    so output is deterministic regardless of the database/OS locale.
    """
    start = date(min_date.year, 1, 1)
    end = date(max_date.year, 12, 31)
    rows = []
    d = start
    while d <= end:
        rows.append((
            date_key(d),
            d,                                  # full_date
            d.year,
            (d.month - 1) // 3 + 1,             # quarter
            d.month,
            calendar.month_name[d.month],       # 'January'..'December'
            d.day,
            calendar.day_name[d.weekday()],     # 'Monday'..'Sunday'
            d.weekday() >= 5,                   # is_weekend (Sat/Sun)
        ))
        d += timedelta(days=1)
    return rows


def build_dim_time() -> list:
    """All 86,400 seconds of a day (00:00:00 .. 23:59:59)."""
    rows = []
    for h in range(24):
        tod = time_of_day(h)
        for m in range(60):
            for s in range(60):
                rows.append((h * 10000 + m * 100 + s, h, m, s, tod))
    return rows


# --- Fact builder ------------------------------------------------------------

@dataclass
class FactBuildResult:
    rows: list = field(default_factory=list)
    collisions: list = field(default_factory=list)        # PK clashes (distinct sales, same cell)
    skipped_missing_dim: list = field(default_factory=list)  # unresolved surrogate key


def _discount(base_price: Decimal, quantity: Decimal, subtotal: Decimal) -> Decimal:
    """Line discount = what the line would cost at base price, minus what was paid.

    Always >= 0 here because the source guarantees unit_price <= base_price.
    """
    gross = (base_price * quantity).quantize(_CENTS, rounding=ROUND_HALF_UP)
    return gross - subtotal


def build_fact_rows(sales_lines, branch_map, product_map, method_map) -> FactBuildResult:
    """Resolve surrogate keys, derive measures, and detect PK collisions.

    The fact PK is the 5 dimension keys, so two distinct sales landing in the
    same (date, second, branch, product, payment) cell collide. We keep the
    first and report the rest instead of letting the DB silently reject them.
    """
    result = FactBuildResult()
    seen: dict = {}  # 5-key tuple -> sale_id kept for that cell
    for line in sales_lines:
        ts: datetime = line["sale_ts"]
        dk = date_key(ts.date())
        tk = time_key(ts)
        bk = branch_map.get(line["branch_id"])
        pk = product_map.get(line["product_id"])
        mk = method_map.get(line["method_name"])

        if bk is None or pk is None or mk is None:
            result.skipped_missing_dim.append({
                "sale_id": line["sale_id"],
                "branch_id": line["branch_id"],
                "product_id": line["product_id"],
                "method_name": line["method_name"],
            })
            continue

        key = (dk, tk, bk, pk, mk)
        if key in seen:
            result.collisions.append({
                "key": key,
                "kept_sale_id": seen[key],
                "dropped_sale_id": line["sale_id"],
                "product_id": line["product_id"],
            })
            continue
        seen[key] = line["sale_id"]

        result.rows.append((
            dk, tk, bk, pk, mk,
            line["sale_id"],
            line["ticket_number"],
            line["quantity"],
            line["unit_price"],
            line["base_price_at_sale"],
            line["subtotal"],
            _discount(line["base_price_at_sale"], line["quantity"], line["subtotal"]),
        ))
    return result
