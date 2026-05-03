#!/usr/bin/env python3
"""export_review_results.py — dump review-cycle results for adjudication.

Produces three files in the active cycle directory (default:
~/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/review_cycles/cycle_<TODAY>/;
override with MCA_REVIEW_CYCLE_DIR env var):

  votes_<YYYY-MM-DD>.csv
      Long-format vote matrix — one row per (token, association_uid).
      Tokens are abbreviated to their first 8 chars to make spot-checking
      easier; the full token is kept too in case you need to dedup.
      Columns: token_short, token_full, association_uid, pmid,
               curated_evidence, evidence_vote, text_vote, comment

  tally_<YYYY-MM-DD>.json
      Anonymous per-association summary keyed by association_uid:
        {
          "<uid>": {
            "pmid": 12345,
            "taxon_name": "...",
            "association_text": "...",
            "curated_evidence": "E2",
            "n_reviewers": 3,
            "evidence_tally": {"E3": 1, "E2": 2, "E1": 0, "UNDETERMINED": 0},
            "text_tally":     {"accurate": 2, "overstated": 1, "understated": 0, "unsure": 0},
            "comments": ["...", "..."]
          },
          ...
        }

  context_comments_<YYYY-MM-DD>.json
      Per-(token, paper) context comments — one entry per non-empty
      review_paper.context_comment.

Usage (run from repo root):
    python3 scripts/export_review_results.py
    python3 scripts/export_review_results.py --out /custom/dir
"""

import argparse
import csv
import json
import sys
from collections import defaultdict
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _db     # noqa: E402
import _paths  # noqa: E402

EV_KEYS = ["E3", "E2", "E1", "UNDETERMINED"]
TX_KEYS = ["accurate", "overstated", "understated", "unsure"]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--out", type=Path, default=None,
                    help="output directory (default: active review cycle dir)")
    args = ap.parse_args()

    out_dir: Path = args.out if args.out else _paths.cycle_dir()
    out_dir.mkdir(parents=True, exist_ok=True)
    today = date.today().isoformat()

    with _db.mca_review() as conn, conn.cursor() as c:
        c.execute(
            """
            SELECT v.token, v.association_uid, v.pmid,
                   v.evidence_vote, v.text_vote, v.comment,
                   a.taxon_name, a.association_text, a.evidence_level AS curated_evidence
            FROM review_vote v
            JOIN association_snapshot a ON a.association_uid = v.association_uid
            ORDER BY v.pmid, a.taxon_name, v.association_uid, v.token
            """
        )
        votes = c.fetchall()

        c.execute(
            """
            SELECT rp.token, rp.pmid, rp.context_comment, ps.title
            FROM review_paper rp
            JOIN paper_snapshot ps ON ps.pmid = rp.pmid
            WHERE rp.context_comment IS NOT NULL AND rp.context_comment <> ''
            ORDER BY rp.pmid
            """
        )
        ctx_comments = c.fetchall()

        # Pull every association so the tally is complete (zero-vote
        # associations still show up with empty counts).
        c.execute(
            "SELECT association_uid, pmid, taxon_name, association_text, evidence_level "
            "FROM association_snapshot ORDER BY pmid, taxon_name, association_uid"
        )
        all_assocs = c.fetchall()

    # ── votes_<DATE>.csv ────────────────────────────────────────────────
    votes_path = out_dir / f"votes_{today}.csv"
    with votes_path.open("w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow([
            "token_short", "token_full", "pmid", "taxon_name",
            "association_uid", "association_text",
            "curated_evidence", "evidence_vote", "text_vote", "comment",
        ])
        for v in votes:
            w.writerow([
                v["token"][:8], v["token"], v["pmid"], v["taxon_name"],
                v["association_uid"], v["association_text"],
                v["curated_evidence"], v["evidence_vote"] or "",
                v["text_vote"] or "", v["comment"] or "",
            ])

    # ── tally_<DATE>.json ───────────────────────────────────────────────
    tally: dict[str, dict] = {}
    for a in all_assocs:
        tally[a["association_uid"]] = {
            "pmid":             a["pmid"],
            "taxon_name":       a["taxon_name"],
            "association_text": a["association_text"],
            "curated_evidence": a["evidence_level"],
            "n_reviewers":      0,
            "evidence_tally":   {k: 0 for k in EV_KEYS},
            "text_tally":       {k: 0 for k in TX_KEYS},
            "comments":         [],
        }

    seen_tokens_per_uid: dict[str, set] = defaultdict(set)
    for v in votes:
        uid = v["association_uid"]
        entry = tally.get(uid)
        if not entry:
            continue
        seen_tokens_per_uid[uid].add(v["token"])
        if v["evidence_vote"]:
            entry["evidence_tally"][v["evidence_vote"]] += 1
        else:
            # Reviewer engaged with this card (vote row exists) but did not
            # change the evidence button — count as implicit agreement with
            # the curator's grade. UNCERTAIN -> UNDETERMINED for the tally key.
            curated = entry["curated_evidence"] or ""
            key = "UNDETERMINED" if curated == "UNCERTAIN" else curated
            if key in entry["evidence_tally"]:
                entry["evidence_tally"][key] += 1
        if v["text_vote"]:
            entry["text_tally"][v["text_vote"]] += 1
        if v["comment"] and v["comment"].strip():
            entry["comments"].append(v["comment"].strip())
    for uid, toks in seen_tokens_per_uid.items():
        tally[uid]["n_reviewers"] = len(toks)

    tally_path = out_dir / f"tally_{today}.json"
    tally_path.write_text(
        json.dumps(tally, indent=2, ensure_ascii=False)
    )

    # ── context_comments_<DATE>.json ────────────────────────────────────
    ctx_path = out_dir / f"context_comments_{today}.json"
    ctx_payload = [
        {
            "token_short": c["token"][:8],
            "pmid":        c["pmid"],
            "title":       c["title"],
            "comment":     c["context_comment"],
        }
        for c in ctx_comments
    ]
    ctx_path.write_text(
        json.dumps(ctx_payload, indent=2, ensure_ascii=False)
    )

    # ── summary ─────────────────────────────────────────────────────────
    n_votes = len(votes)
    n_assocs_with_votes = sum(1 for e in tally.values() if e["n_reviewers"] > 0)
    n_text_total = sum(sum(e["text_tally"].values()) for e in tally.values())
    n_text_unsure = sum(e["text_tally"]["unsure"] for e in tally.values())
    coverage = n_assocs_with_votes / max(1, len(tally)) * 100

    print(f"Output dir            : {out_dir}")
    print(f"Files written         : {votes_path.name}, {tally_path.name}, {ctx_path.name}")
    print()
    print(f"Vote rows             : {n_votes}")
    print(f"Associations covered  : {n_assocs_with_votes} / {len(tally)} ({coverage:.0f}%)")
    print(f"Quality votes total   : {n_text_total} (incl. 'unsure': {n_text_unsure})")
    print(f"Context comments      : {len(ctx_comments)}")


if __name__ == "__main__":
    main()
