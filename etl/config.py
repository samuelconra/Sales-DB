"""Central configuration for the Sales OLTP -> OLAP ETL.

Settings are read from environment variables (optionally loaded from a local
``etl/.env`` file) with sensible defaults that match the project's standard
Docker setup:

    * OLTP source : postgres on localhost:5432, db ``sales_hans``, schema ``hans``
    * OLAP target : postgres on localhost:5433, db ``sales_dw_local``, schema ``public``
"""
from __future__ import annotations

import os
import re
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv

# Load etl/.env if present (does not override variables already exported).
ETL_DIR = Path(__file__).resolve().parent
load_dotenv(ETL_DIR / ".env")

_IDENT_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def _validate_identifier(name: str, what: str) -> str:
    """Guard against injection for identifiers we must interpolate (schema)."""
    if not _IDENT_RE.match(name):
        raise ValueError(f"Unsafe {what}: {name!r}")
    return name


@dataclass(frozen=True)
class DbConfig:
    host: str
    port: int
    dbname: str
    user: str
    password: str
    schema: str

    def dsn_kwargs(self) -> dict:
        return {
            "host": self.host,
            "port": self.port,
            "dbname": self.dbname,
            "user": self.user,
            "password": self.password,
        }

    def safe_schema(self) -> str:
        return _validate_identifier(self.schema, "schema name")

    def label(self) -> str:
        return f"{self.host}:{self.port}/{self.dbname}"


def _db_from_env(prefix: str, defaults: dict) -> DbConfig:
    return DbConfig(
        host=os.getenv(f"{prefix}_HOST", defaults["host"]),
        port=int(os.getenv(f"{prefix}_PORT", defaults["port"])),
        dbname=os.getenv(f"{prefix}_DB", defaults["dbname"]),
        user=os.getenv(f"{prefix}_USER", defaults["user"]),
        password=os.getenv(f"{prefix}_PASSWORD", defaults["password"]),
        schema=os.getenv(f"{prefix}_SCHEMA", defaults["schema"]),
    )


SOURCE = _db_from_env(
    "SRC",
    {
        "host": "localhost", "port": 5432, "dbname": "sales_hans",
        "user": "postgres", "password": "hans_password!", "schema": "hans",
    },
)

TARGET = _db_from_env(
    "DW",
    {
        "host": "localhost", "port": 5433, "dbname": "sales_dw_local",
        "user": "postgres", "password": "password", "schema": "public",
    },
)

# Timezone used to derive date_key / time_key from the TIMESTAMPTZ sale_date.
ETL_TIMEZONE = os.getenv("ETL_TIMEZONE", "UTC")
# Rows per bulk-insert chunk (capped further by PostgreSQL's parameter limit).
BATCH_SIZE = int(os.getenv("ETL_BATCH_SIZE", "5000"))
LOG_LEVEL = os.getenv("ETL_LOG_LEVEL", "INFO").upper()
