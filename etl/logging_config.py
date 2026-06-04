"""Logging setup shared by the ETL entrypoint."""
from __future__ import annotations

import logging
import sys

from config import LOG_LEVEL


def configure_logging() -> logging.Logger:
    logging.basicConfig(
        level=LOG_LEVEL,
        stream=sys.stdout,
        format="%(asctime)s | %(levelname)-7s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    return logging.getLogger("etl")
