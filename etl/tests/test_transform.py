"""Unit tests for the pure transform layer (no database required)."""
from datetime import datetime
from decimal import Decimal

from pipeline import transform as t


def test_date_key():
    assert t.date_key(datetime(2024, 3, 7).date()) == 20240307


def test_time_key():
    assert t.time_key(datetime(2024, 1, 1, 9, 5, 3)) == 90503
    assert t.time_key(datetime(2024, 1, 1, 0, 0, 0)) == 0
    assert t.time_key(datetime(2024, 1, 1, 23, 59, 59)) == 235959


def test_time_of_day_buckets():
    assert t.time_of_day(0) == "Night"
    assert t.time_of_day(6) == "Morning"
    assert t.time_of_day(12) == "Afternoon"
    assert t.time_of_day(18) == "Evening"
    assert t.time_of_day(23) == "Evening"


def test_build_dim_time_is_complete():
    rows = t.build_dim_time()
    assert len(rows) == 86_400
    assert rows[0] == (0, 0, 0, 0, "Night")
    assert rows[-1] == (235959, 23, 59, 59, "Evening")


def test_build_dim_date_pads_to_whole_years():
    rows = t.build_dim_date(datetime(2023, 6, 15).date(), datetime(2024, 2, 10).date())
    assert rows[0][0] == 20230101          # first padded day
    assert rows[-1][0] == 20241231          # last padded day
    # 2023 (365) + 2024 (366, leap) = 731 days
    assert len(rows) == 731
    # Spot-check a known weekday: 2023-06-15 was a Thursday, not a weekend.
    by_key = {r[0]: r for r in rows}
    jun15 = by_key[20230615]
    assert jun15[5] == "June" and jun15[7] == "Thursday" and jun15[8] is False
    # 2023-06-17 was a Saturday.
    assert by_key[20230617][8] is True


def _line(**kw):
    base = dict(
        sale_id=1, ticket_number="TKT-1", branch_id=10, product_id=20,
        method_name="CARD", quantity=Decimal("2.000"),
        unit_price=Decimal("95.00"), base_price_at_sale=Decimal("100.00"),
        subtotal=Decimal("190.00"), sale_ts=datetime(2024, 5, 4, 14, 30, 15),
    )
    base.update(kw)
    return base


def test_build_fact_rows_resolves_keys_and_discount():
    res = t.build_fact_rows(
        [_line()],
        branch_map={10: 100}, product_map={20: 200}, method_map={"CARD": 1},
    )
    assert not res.collisions and not res.skipped_missing_dim
    (row,) = res.rows
    # date_key, time_key, branch_key, product_key, payment_method_key
    assert row[0] == 20240504 and row[1] == 143015
    assert row[2] == 100 and row[3] == 200 and row[4] == 1
    # discount = 100.00*2 - 190.00 = 10.00
    assert row[-1] == Decimal("10.00")


def test_build_fact_rows_flags_missing_dimension():
    res = t.build_fact_rows(
        [_line(branch_id=999)],
        branch_map={10: 100}, product_map={20: 200}, method_map={"CARD": 1},
    )
    assert res.rows == [] and len(res.skipped_missing_dim) == 1


def test_build_fact_rows_detects_pk_collision():
    # Two distinct sales in the same date/second/branch/product/payment cell.
    a = _line(sale_id=1)
    b = _line(sale_id=2)
    res = t.build_fact_rows(
        [a, b],
        branch_map={10: 100}, product_map={20: 200}, method_map={"CARD": 1},
    )
    assert len(res.rows) == 1
    assert len(res.collisions) == 1
    assert res.collisions[0]["kept_sale_id"] == 1
    assert res.collisions[0]["dropped_sale_id"] == 2
