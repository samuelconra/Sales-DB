"""Load step: full-refresh the warehouse and resolve surrogate keys.

Strategy (chosen for this project): TRUNCATE ... RESTART IDENTITY then bulk
reload. This is fully idempotent and deterministic for the data volume here
(~25k fact rows load in well under a second).
"""
from __future__ import annotations

from pathlib import Path

import config

# PostgreSQL caps a statement at 65535 bind parameters; stay safely under it.
_MAX_PARAMS = 65000

# olap/dw/*.sql lives two levels up from etl/pipeline/.
OLAP_DDL_DIR = Path(__file__).resolve().parent.parent.parent / "olap" / "dw"

# Child first so RESTART IDENTITY can reset every SERIAL each run.
TRUNCATE_ORDER = (
    "fact_sales",
    "dim_branch",
    "dim_product",
    "dim_payment_method",
    "dim_date",
    "dim_time",
)


def apply_schema(conn) -> list:
    """Idempotently (re)create the star schema from the olap/dw/*.sql files.

    The DDL files all use ``CREATE TABLE IF NOT EXISTS``, so this is safe to run
    against an already-initialized warehouse.
    """
    files = sorted(OLAP_DDL_DIR.glob("*.sql"))
    with conn.cursor() as cur:
        for f in files:
            cur.execute(f.read_text(encoding="utf-8"))
    conn.commit()
    return [f.name for f in files]


def truncate_targets(conn) -> None:
    tables = ", ".join(TRUNCATE_ORDER)
    with conn.cursor() as cur:
        cur.execute(f"TRUNCATE {tables} RESTART IDENTITY CASCADE")
    conn.commit()


def bulk_insert(conn, table, columns, rows, conflict_cols=None, page_size=None) -> int:
    """Chunked multi-row INSERT. Optional ON CONFLICT (...) DO NOTHING.

    Each chunk is a single ``INSERT ... VALUES (...),(...),...`` round-trip. The
    chunk size is capped so the bind-parameter count stays under PostgreSQL's
    limit. Collision pre-filtering happens in the transform layer, so the
    ON CONFLICT clause here is only a defensive safety net.
    """
    if not rows:
        return 0
    ncols = len(columns)
    page_size = page_size or config.BATCH_SIZE
    page_size = min(page_size, max(1, _MAX_PARAMS // ncols))

    col_list = ", ".join(columns)
    one_row = "(" + ", ".join(["%s"] * ncols) + ")"
    suffix = ""
    if conflict_cols:
        suffix = f" ON CONFLICT ({', '.join(conflict_cols)}) DO NOTHING"

    with conn.cursor() as cur:
        for start in range(0, len(rows), page_size):
            chunk = rows[start:start + page_size]
            placeholders = ", ".join([one_row] * len(chunk))
            sql = f"INSERT INTO {table} ({col_list}) VALUES {placeholders}{suffix}"
            flat = [value for row in chunk for value in row]
            cur.execute(sql, flat)
    conn.commit()
    return len(rows)


def build_key_map(conn, table, natural_col, surrogate_col) -> dict:
    """Read back a {natural_key: surrogate_key} map after a dimension load."""
    with conn.cursor() as cur:
        cur.execute(f"SELECT {natural_col}, {surrogate_col} FROM {table}")
        return {natural: surrogate for natural, surrogate in cur.fetchall()}
