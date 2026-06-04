# Sales ETL — OLTP → OLAP

Python ETL that moves data from the transactional **`hans`** schema (OLTP) into the
star-schema **Data Warehouse** (`sales_dw_local`) that feeds Qlik Sense.

It is a **full-refresh** pipeline: every run rebuilds the warehouse deterministically
(`TRUNCATE … RESTART IDENTITY` → bulk reload), so it is safe to re-run any time.

---

## Architecture

```
 OLTP (hans @ :5432)                                       OLAP / DW (public @ :5433)
 ┌─────────────────────┐                                  ┌──────────────────────────┐
 │ countries  states   │   extract                        │ dim_date    dim_time     │
 │ branches            │  ──────────►  transform  ──────► │  dim_branch               │
 │ categories products │                (Python)   load   │ dim_product              │
 │ sales  sale_details │                                  │ dim_payment_method       │
 └─────────────────────┘                                  │ fact_sales               │
                                                          └──────────────────────────┘
```

| Stage | Module | What it does |
|---|---|---|
| Extract | [pipeline/extract.py](pipeline/extract.py) + [sql/](sql/) | Pull denormalized source rows from the OLTP. |
| Transform | [pipeline/transform.py](pipeline/transform.py) | Generate date/time dims, smart keys, discounts; detect PK collisions. *(pure / unit-tested)* |
| Load | [pipeline/load.py](pipeline/load.py) | Truncate, bulk-insert, read back surrogate-key maps. |
| Validate | [pipeline/validate.py](pipeline/validate.py) | Row counts, source reconciliation, integrity & sanity checks. |
| Orchestrate | [run_etl.py](run_etl.py) | Wires the stages together with logging and exit codes. |

---

## Source → Target mapping

| Target table | Source | Notes |
|---|---|---|
| `dim_branch` | `branches ⋈ states ⋈ countries` | Flattened; `branch_key` is a generated surrogate. |
| `dim_product` | `products ⋈ categories` | Flattened; `current_base_price = products.base_price`. |
| `dim_payment_method` | `payment_method` ENUM | All enum values (`CARD`, `CASH`), even if unused. |
| `dim_date` | generated | Every day from `min..max(sale_date)`, padded to whole years. |
| `dim_time` | generated | All 86,400 seconds; `time_of_day` bucketed (Night/Morning/Afternoon/Evening). |
| `fact_sales` | `sale_details ⋈ sales ⋈ products` | Grain = one sale line; surrogate keys resolved in memory. |

**Derived measures**

| Column | Rule |
|---|---|
| `date_key` | `YYYYMMDD` from `sale_date` (see timezone note). |
| `time_key` | `HHMMSS` from `sale_date`. |
| `base_price_at_sale` | `products.base_price` (current). |
| `discount_amount` | `round(base_price × quantity, 2) − subtotal` (always ≥ 0). |

---

## Prerequisites

Both databases must be running and reachable:

```bash
# OLTP source  (from the repo root)
docker compose up -d
# OLAP target  (from olap/)
cd olap && docker compose up -d && cd -
```

Defaults assume OLTP on `localhost:5432` (`sales_hans`) and the DW on
`localhost:5433` (`sales_dw_local`). Override any of these in `etl/.env`.

---

## Usage

```bash
cd etl
make setup        # create .venv, install deps, scaffold .env

make run          # full-refresh load (DW schema must already exist)
make run-fresh    # apply olap/dw DDL (idempotent) first, then load
make validate     # run data-quality checks only
make test         # unit tests for the transform layer
```

Or directly:

```bash
python run_etl.py [--init-schema] [--validate-only]
```

Exit codes: `0` success · `1` validation failed · `2` unhandled error.

---

## Configuration ([.env.example](.env.example))

| Var | Default | Purpose |
|---|---|---|
| `SRC_HOST/PORT/DB/USER/PASSWORD/SCHEMA` | `localhost:5432 / sales_hans / postgres / hans_password! / hans` | OLTP source |
| `DW_HOST/PORT/DB/USER/PASSWORD/SCHEMA` | `localhost:5433 / sales_dw_local / postgres / password / public` | OLAP target |
| `ETL_TIMEZONE` | `UTC` | Zone for `date_key` / `time_key` |
| `ETL_BATCH_SIZE` | `5000` | Bulk-insert page size |
| `ETL_LOG_LEVEL` | `INFO` | Logging verbosity |
