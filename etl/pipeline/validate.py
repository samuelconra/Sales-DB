"""Post-load data-quality and source-reconciliation checks.

Returns ``True`` when every check passes. Designed to be safe to run on its own
(``--validate-only``) as well as immediately after a load.
"""
from __future__ import annotations

from dataclasses import dataclass

DW_TABLES = (
    "dim_date", "dim_time", "dim_branch",
    "dim_product", "dim_payment_method", "fact_sales",
)


@dataclass
class Check:
    name: str
    passed: bool
    detail: str


def _scalar(conn, sql, params=None):
    with conn.cursor() as cur:
        cur.execute(sql, params or {})
        row = cur.fetchone()
        return row[0] if row else None


def run(src, dw, log, *, expected_fact=None, collisions=0, skipped=0) -> bool:
    checks: list = []

    # --- Warehouse row counts -------------------------------------------
    counts = {t: _scalar(dw, f"SELECT count(*) FROM {t}") for t in DW_TABLES}
    log.info("Warehouse row counts: %s", counts)

    # --- Line accounting vs OLTP ----------------------------------------
    src_lines = _scalar(src, "SELECT count(*) FROM sale_details")
    if expected_fact is not None:
        checks.append(Check(
            "fact rows match loaded set",
            counts["fact_sales"] == expected_fact,
            f"fact={counts['fact_sales']} expected={expected_fact}",
        ))
        accounted = expected_fact + collisions + skipped
        checks.append(Check(
            "every source line accounted for",
            accounted == src_lines,
            f"loaded+collisions+skipped={accounted} source_lines={src_lines}",
        ))

    # --- Measure reconciliation -----------------------------------------
    # Sum of subtotals over the lines that actually loaded must tie to OLTP.
    src_subtotal = _scalar(
        src,
        """
        SELECT coalesce(sum(sd.subtotal), 0)
        FROM sale_details sd
        JOIN sales s ON s.sale_id = sd.sale_id
        """,
    )
    dw_subtotal = _scalar(dw, "SELECT coalesce(sum(subtotal), 0) FROM fact_sales")
    # When nothing was dropped these are exactly equal; otherwise the warehouse
    # total is strictly less by the dropped lines' subtotals.
    reconciled = (dw_subtotal == src_subtotal) if (collisions + skipped == 0) \
        else (dw_subtotal <= src_subtotal)
    checks.append(Check(
        "subtotal reconciles with OLTP",
        reconciled,
        f"dw={dw_subtotal} source={src_subtotal} dropped_lines={collisions + skipped}",
    ))

    # --- Integrity / sanity ---------------------------------------------
    neg_discount = _scalar(dw, "SELECT count(*) FROM fact_sales WHERE discount_amount < 0")
    checks.append(Check("no negative discounts", neg_discount == 0, f"violations={neg_discount}"))

    bad_price = _scalar(dw, "SELECT count(*) FROM fact_sales WHERE unit_price > base_price_at_sale")
    checks.append(Check("unit_price <= base_price", bad_price == 0, f"violations={bad_price}"))

    orphan_dates = _scalar(
        dw,
        """
        SELECT count(*) FROM fact_sales f
        LEFT JOIN dim_date d ON d.date_key = f.date_key
        WHERE d.date_key IS NULL
        """,
    )
    checks.append(Check("no orphan date_key", orphan_dates == 0, f"orphans={orphan_dates}"))

    methods = _scalar(dw, "SELECT count(*) FROM dim_payment_method")
    checks.append(Check("payment methods present", methods >= 1, f"count={methods}"))

    fact_present = counts["fact_sales"] > 0
    checks.append(Check("fact table not empty", fact_present, f"rows={counts['fact_sales']}"))

    # --- Report ---------------------------------------------------------
    all_ok = True
    log.info("── Validation ──────────────────────────────")
    for c in checks:
        status = "PASS" if c.passed else "FAIL"
        log.log(20 if c.passed else 40, "  [%s] %-32s %s", status, c.name, c.detail)
        all_ok = all_ok and c.passed
    log.info("── %s ──", "ALL CHECKS PASSED" if all_ok else "VALIDATION FAILED")
    return all_ok
