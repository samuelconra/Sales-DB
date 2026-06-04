"""Thin psycopg (v3) connection helpers."""
from __future__ import annotations

import contextlib
from typing import Iterator

import psycopg

from config import DbConfig


@contextlib.contextmanager
def connect(cfg: DbConfig, *, set_search_path: bool = True) -> Iterator[psycopg.Connection]:
    """Open a connection and (by default) pin the search_path to ``cfg.schema``.

    Pinning the search_path lets every query reference tables unqualified,
    keeping the SQL files schema-agnostic and reusable across environments.
    """
    conn = psycopg.connect(**cfg.dsn_kwargs())
    try:
        if set_search_path:
            conn.execute(f"SET search_path TO {cfg.safe_schema()}")
            conn.commit()
        yield conn
    finally:
        conn.close()
