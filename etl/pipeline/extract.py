"""Extract step: pull denormalized source data out of the OLTP database.

Each function returns a list of dict-like rows (``RealDictRow``) whose keys match
the SELECT aliases in the corresponding ``etl/sql/extract_*.sql`` file.
"""
from __future__ import annotations

from pathlib import Path
from typing import Optional

from psycopg.rows import dict_row

SQL_DIR = Path(__file__).resolve().parent.parent / "sql"


def _read_sql(name: str) -> str:
    return (SQL_DIR / name).read_text(encoding="utf-8")


def _fetch_all(conn, sql: str, params: Optional[dict] = None) -> list:
    with conn.cursor(row_factory=dict_row) as cur:
        cur.execute(sql, params or {})
        return cur.fetchall()


def fetch_branches(conn) -> list:
    return _fetch_all(conn, _read_sql("extract_branches.sql"))


def fetch_products(conn) -> list:
    return _fetch_all(conn, _read_sql("extract_products.sql"))


def fetch_payment_methods(conn) -> list:
    return _fetch_all(conn, _read_sql("extract_payment_methods.sql"))


def fetch_sales_lines(conn, tz: str) -> list:
    return _fetch_all(conn, _read_sql("extract_sales_lines.sql"), {"tz": tz})
