#!/usr/bin/env python3
"""Sales OLTP -> OLAP ETL orchestrator (full-refresh).

Pipeline:
    extract (OLTP) -> truncate (DW) -> load dims -> resolve keys -> load fact -> validate

Usage:
    python run_etl.py                 # full refresh against an existing DW schema
    python run_etl.py --init-schema   # (re)apply olap/dw DDL first, then load
    python run_etl.py --validate-only # only run data-quality checks
"""
from __future__ import annotations

import argparse
import sys
import time

import config
import db
from logging_config import configure_logging
from pipeline import extract, load, transform, validate

# Dict-key -> column order for the denormalized dimension loads.
DIM_BRANCH_COLUMNS = (
    "branch_id", "branch_name", "address",
    "state_code", "state_name", "country_code", "country_name",
)
DIM_PRODUCT_COLUMNS = (
    "product_id", "sku", "barcode", "product_name",
    "current_base_price", "category_name", "category_description",
)


def _rows(records, columns):
    """Project a list of dict-like records into tuples in column order."""
    return [tuple(r[c] for c in columns) for r in records]


def parse_args(argv=None):
    p = argparse.ArgumentParser(description="Sales OLTP -> OLAP ETL (full refresh).")
    p.add_argument("--init-schema", action="store_true",
                   help="Apply olap/dw/*.sql (idempotent) before loading.")
    p.add_argument("--validate-only", action="store_true",
                   help="Run validation against the current warehouse and exit.")
    return p.parse_args(argv)


def run(args) -> int:
    log = configure_logging()
    log.info("Source : %s (schema=%s)", config.SOURCE.label(), config.SOURCE.schema)
    log.info("Target : %s (schema=%s)", config.TARGET.label(), config.TARGET.schema)
    log.info("Timezone for date/time keys: %s", config.ETL_TIMEZONE)
    started = time.perf_counter()

    with db.connect(config.SOURCE) as src, db.connect(config.TARGET) as dw:
        if args.init_schema:
            applied = load.apply_schema(dw)
            log.info("Applied target schema: %s", ", ".join(applied))

        if args.validate_only:
            ok = validate.run(src, dw, log)
            return 0 if ok else 1

        # 1) Extract -----------------------------------------------------
        log.info("Extracting from OLTP...")
        branches = extract.fetch_branches(src)
        products = extract.fetch_products(src)
        methods = extract.fetch_payment_methods(src)
        lines = extract.fetch_sales_lines(src, config.ETL_TIMEZONE)
        log.info("Extracted: branches=%d products=%d methods=%d sale_lines=%d",
                 len(branches), len(products), len(methods), len(lines))
        if not lines:
            log.error("No sale lines found in source — aborting.")
            return 1

        # 2) Truncate (full refresh) ------------------------------------
        load.truncate_targets(dw)
        log.info("Warehouse truncated (RESTART IDENTITY)")

        # 3) Date & time dimensions (generated) -------------------------
        sale_dates = [ln["sale_ts"].date() for ln in lines]
        dim_date_rows = transform.build_dim_date(min(sale_dates), max(sale_dates))
        dim_time_rows = transform.build_dim_time()
        load.bulk_insert(dw, "dim_date", transform.DIM_DATE_COLUMNS, dim_date_rows)
        load.bulk_insert(dw, "dim_time", transform.DIM_TIME_COLUMNS, dim_time_rows)
        log.info("Loaded dim_date=%d dim_time=%d", len(dim_date_rows), len(dim_time_rows))

        # 4) Denormalized dimensions ------------------------------------
        load.bulk_insert(dw, "dim_branch", DIM_BRANCH_COLUMNS, _rows(branches, DIM_BRANCH_COLUMNS))
        load.bulk_insert(dw, "dim_product", DIM_PRODUCT_COLUMNS, _rows(products, DIM_PRODUCT_COLUMNS))
        load.bulk_insert(dw, "dim_payment_method", ("method_name",),
                         [(m["method_name"],) for m in methods])
        log.info("Loaded dim_branch=%d dim_product=%d dim_payment_method=%d",
                 len(branches), len(products), len(methods))

        # 5) Resolve surrogate keys -------------------------------------
        branch_map = load.build_key_map(dw, "dim_branch", "branch_id", "branch_key")
        product_map = load.build_key_map(dw, "dim_product", "product_id", "product_key")
        method_map = load.build_key_map(dw, "dim_payment_method", "method_name", "payment_method_key")

        # 6) Build & load fact ------------------------------------------
        fact = transform.build_fact_rows(lines, branch_map, product_map, method_map)
        load.bulk_insert(dw, "fact_sales", transform.FACT_COLUMNS, fact.rows,
                         conflict_cols=transform.FACT_PK)
        log.info("Loaded fact_sales=%d (PK collisions skipped=%d, missing-dim skipped=%d)",
                 len(fact.rows), len(fact.collisions), len(fact.skipped_missing_dim))
        for c in fact.collisions:
            log.warning("PK collision @ %s: kept sale_id=%s, dropped sale_id=%s (product_id=%s)",
                        c["key"], c["kept_sale_id"], c["dropped_sale_id"], c["product_id"])
        for s in fact.skipped_missing_dim:
            log.warning("Skipped line (unresolved dim): %s", s)

        # 7) Validate ----------------------------------------------------
        ok = validate.run(src, dw, log,
                           expected_fact=len(fact.rows),
                           collisions=len(fact.collisions),
                           skipped=len(fact.skipped_missing_dim))

    elapsed = time.perf_counter() - started
    log.info("ETL %s in %.2fs", "completed" if ok else "completed WITH FAILURES", elapsed)
    return 0 if ok else 1


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        return run(args)
    except Exception:  # noqa: BLE001 - top-level guard logs full traceback
        configure_logging().exception("ETL failed with an unhandled error")
        return 2


if __name__ == "__main__":
    sys.exit(main())
