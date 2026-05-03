#!/usr/bin/env python3
"""freeze_reviews.py — lock the review cycle.

Flips every non-frozen `review_paper.status` to 'frozen' (sets
`frozen_at = NOW()`) so review pages render read-only thereafter.
Manual trigger only — no deadline column, no cron.

Usage (run from repo root):
    python3 scripts/freeze_reviews.py            # freeze all unfrozen rows
    python3 scripts/freeze_reviews.py --revoke   # also revoke every token

By default, tokens stay valid so frozen pages still render (read-only).
Pass --revoke to invalidate tokens entirely (URLs return 403).
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _db  # noqa: E402


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--revoke", action="store_true",
                    help="also UPDATE review_token SET revoked_at = NOW()")
    args = ap.parse_args()

    with _db.mca_review() as conn, conn.cursor() as c:
        c.execute(
            "UPDATE review_paper SET status='frozen', frozen_at=NOW() "
            "WHERE status <> 'frozen'"
        )
        n_frozen = c.rowcount

        n_revoked = 0
        if args.revoke:
            c.execute(
                "UPDATE review_token SET revoked_at = NOW() "
                "WHERE revoked_at IS NULL"
            )
            n_revoked = c.rowcount

        conn.commit()

    print(f"Frozen review_paper rows : {n_frozen}")
    if args.revoke:
        print(f"Revoked tokens           : {n_revoked}")


if __name__ == "__main__":
    main()
