#!/usr/bin/env python3
"""mint_tokens.py — generate N reviewer tokens and pre-populate review_paper rows.

Each token gets one row per paper in MCA_review.paper_snapshot — every
reviewer sees the same paper list. There is no per-reviewer assignment.

Outputs:
  - N rows in MCA_review.review_token
  - N x P rows in MCA_review.review_paper (P = number of papers)
  - <cycle_dir>/tokens.md with the full URL list
    (cycle_dir defaults to Dropbox: ~/.../mca/review_cycles/cycle_<TODAY>/;
     override with MCA_REVIEW_CYCLE_DIR env var)

The cycle file is the curator's only place to find tokens after this
script runs — keep it private (Dropbox is fine; never check into git).

Usage (run from repo root):
    python3 scripts/mint_tokens.py 5

Override the URL base (production deploy) via env var:
    MCA_REVIEW_BASE_URL=https://mca.thebiohub.ca python3 scripts/mint_tokens.py 5
"""

import argparse
import secrets
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _db     # noqa: E402
import _paths  # noqa: E402


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("n", type=int, help="number of tokens to mint")
    args = ap.parse_args()
    if args.n < 1:
        sys.exit("ERROR: N must be >= 1")

    base_url = _db.base_url()
    now = datetime.now(timezone.utc).replace(tzinfo=None)

    with _db.mca_review() as conn, conn.cursor() as c:
        c.execute("SELECT pmid, title FROM paper_snapshot ORDER BY pmid")
        papers = c.fetchall()
        if not papers:
            sys.exit(
                "ERROR: paper_snapshot is empty. Run ingest_for_review.py first."
            )

        tokens = [secrets.token_hex(32) for _ in range(args.n)]
        c.executemany(
            "INSERT INTO review_token (token, created_at) VALUES (%s, %s)",
            [(t, now) for t in tokens],
        )

        rows = [(t, p["pmid"]) for t in tokens for p in papers]
        c.executemany(
            "INSERT INTO review_paper (token, pmid) VALUES (%s, %s)",
            rows,
        )
        conn.commit()

    lines = [
        f"# Reviewer tokens minted {now:%Y-%m-%d %H:%M UTC}",
        "",
        f"- Base URL : {base_url}",
        f"- Papers   : {len(papers)}",
        f"- Tokens   : {len(tokens)}",
        "",
        "## URLs",
        "",
    ]
    for i, t in enumerate(tokens, 1):
        lines.append(f"{i:2d}. {base_url}/review.php?t={t}")
    lines.append("")
    out_path = _paths.cycle_dir() / "tokens.md"
    out_path.write_text("\n".join(lines))

    print(f"Minted {len(tokens)} tokens; wrote URLs to {out_path}")
    print(f"Pre-populated {len(rows)} review_paper rows ({len(tokens)} x {len(papers)}).")


if __name__ == "__main__":
    main()
