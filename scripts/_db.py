"""Database connection helpers used by review-system scripts.

Connection target is configured via environment variables. Defaults
target the local docker stack (`docker compose up`):

    MCA_DB_HOST   default 127.0.0.1
    MCA_DB_PORT   default 13306
    MCA_DB_USER   default root
    MCA_DB_PASS   default root

Override these to point at production or a different local setup.
"""

import os
import pymysql


def _connect(database: str):
    return pymysql.connect(
        host=os.environ.get("MCA_DB_HOST", "127.0.0.1"),
        port=int(os.environ.get("MCA_DB_PORT", "13306")),
        user=os.environ.get("MCA_DB_USER", "root"),
        password=os.environ.get("MCA_DB_PASS", "root"),
        database=database,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=False,
    )


def mca():
    """Connect to the canonical MCA database (read-only by convention)."""
    return _connect("MCA")


def mca_review():
    """Connect to the review-cycle database (read/write)."""
    return _connect("MCA_review")


def base_url() -> str:
    """Public-facing base URL for review tokens."""
    return os.environ.get("MCA_REVIEW_BASE_URL", "http://localhost:8080")
