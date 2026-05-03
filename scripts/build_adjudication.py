#!/usr/bin/env python3
"""build_adjudication.py — generate the curator's adjudication worksheet (CSV).

Reads `tally_<DATE>.json` (output of export_review_results.py) and
classifies every claim as either auto-resolved (consensus → KEEP) or
needs-curator (split votes or text revisions required). Writes a single
spreadsheet-friendly worksheet inside the active cycle dir:

    <cycle_dir>/adjudication_<DATE>.csv

(cycle_dir defaults to Dropbox: ~/.../mca/review_cycles/cycle_<TODAY>/;
override with MCA_REVIEW_CYCLE_DIR env var.)

Open it in Numbers, Excel, or Google Sheets. Filter by `section ==
needs_curator` to find the work. Each row's `decision_evidence_level`
is pre-filled with the plurality winner; the curator only overrides
when they want to dissent from the majority. The four curator-fillable
columns are at the right edge:

    decision_evidence_level   pre-filled (plurality winner). Override only
                              if you disagree with the majority.
    revised_statement         blank by default. Type corrected wording
                              when text_action_suggested is non-empty.
    discard                   blank by default. Type TRUE only if the
                              claim itself should be removed entirely.
    curator_note              free-text rationale (optional).

Save the file as CSV (do NOT export to xlsx — keep CSV so apply_adjudication.py
can read it). auto_resolved and no_votes rows can be left alone unless
you override.

Auto-classification rules:
  Evidence — "clear" if no reviewer voted for a different definite grade
             (UNDETERMINED counts as abstention). Even with dissent, the
             plurality winner is pre-filled if it's unique; ties leave the
             pre-fill blank so the curator must choose.
  Text     — "clear" if accurate is the plurality (over/under tied or
             absent). Otherwise the suggested action reflects the
             dominant direction: STRENGTHEN, WEAKEN, or REVISE_TEXT_MIXED.

Usage (run from repo root):
    python3 scripts/build_adjudication.py
        [--tally  <cycle_dir>/tally_<DATE>.json]
        [--out    <cycle_dir>/adjudication_<DATE>.csv]
"""

import argparse
import csv
import json
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _llm    # noqa: E402
import _paths  # noqa: E402


def _evidence_decision(curator_grade: str, ev_tally: dict) -> tuple[str, list, str]:
    """Return (clarity, candidate_options, prefill_grade).

    clarity         "clear" (no explicit dissent) or "needs_curator"
    candidate_opts  the curator's grade plus every other definite grade
                    that received >= 1 vote (omitting UNDETERMINED, which
                    counts as abstention).
    prefill_grade   the value to seed decision_evidence_level with:
                      - clear consensus       -> curator's grade
                      - dissent + unique plurality -> the plurality winner
                      - dissent but tied      -> "" (curator must pick)
    """
    cur_key = "UNDETERMINED" if curator_grade == "UNCERTAIN" else curator_grade
    definite = {k: v for k, v in ev_tally.items() if k != "UNDETERMINED" and v > 0}

    dissent = sum(v for k, v in definite.items() if k != cur_key)
    if dissent == 0:
        return "clear", [cur_key], cur_key

    candidates = [cur_key] + [k for k in definite if k != cur_key]

    max_count = max(definite.values())
    winners = [k for k, v in definite.items() if v == max_count]
    prefill = winners[0] if len(winners) == 1 else ""
    return "needs_curator", candidates, prefill


def _text_decision(text_tally: dict) -> tuple[str, str]:
    """Plurality rule: the most-voted text option wins.

    accurate plurality   -> clear, no suggestion
    overstated plurality -> needs_curator, suggest WEAKEN  (text is too strong)
    understated plurality-> needs_curator, suggest STRENGTHEN (text is too weak)
    tied between over/under -> needs_curator, REVISE_TEXT_MIXED
    """
    accurate    = text_tally.get("accurate",    0)
    overstated  = text_tally.get("overstated",  0)
    understated = text_tally.get("understated", 0)

    # accurate is the curator's "no change needed" winner
    if accurate >= overstated and accurate >= understated and accurate > 0:
        return "clear", ""
    if overstated > understated:
        return "needs_curator", "WEAKEN"
    if understated > overstated:
        return "needs_curator", "STRENGTHEN"
    # over == under > 0 -> ambiguous direction
    if overstated > 0:
        return "needs_curator", "REVISE_TEXT_MIXED"
    return "clear", ""


def _classify(entry: dict) -> dict:
    n = entry["n_reviewers"]
    curator = entry["curated_evidence"]
    cur_key = "UNDETERMINED" if curator == "UNCERTAIN" else curator

    if n == 0:
        return {
            "section":               "no_votes",
            "evidence_options":      "",
            "text_action_suggested": "",
            "decision_evidence_level": cur_key,
        }

    ev_state, ev_opts, ev_prefill = _evidence_decision(curator, entry["evidence_tally"])
    tx_state, tx_action = _text_decision(entry["text_tally"])

    if ev_state == "clear" and tx_state == "clear":
        return {
            "section":               "auto_resolved",
            "evidence_options":      "",
            "text_action_suggested": "",
            "decision_evidence_level": cur_key,
        }

    return {
        "section":               "needs_curator",
        "evidence_options":      " | ".join(ev_opts) if ev_state == "needs_curator" else "",
        "text_action_suggested": tx_action,
        "decision_evidence_level": ev_prefill,
    }


def _summary(tally: dict) -> str:
    """Compact 'k1:n1 k2:n2' summary, omitting zero counts."""
    return " ".join(f"{k}:{v}" for k, v in tally.items() if v)


def _contestation(ev_tally: dict, curator_grade: str) -> tuple[int, int]:
    """Sort key for needs_curator rows.

    Returns (n_distinct_buckets, total_dissent) — both larger = more contested.
    """
    cur_key = "UNDETERMINED" if curator_grade == "UNCERTAIN" else curator_grade
    n_distinct = sum(1 for v in ev_tally.values() if v > 0)
    dissent = sum(v for k, v in ev_tally.items() if k != cur_key and v > 0)
    return n_distinct, dissent


# Column order is chosen for spreadsheet readability:
# context first, votes in the middle, decision fields at the right.
COLUMNS = [
    "section",
    "pmid",
    "taxon_name",
    "association_text",
    "curated_evidence",
    "n_reviewers",
    "evidence_summary",
    "text_summary",
    "comments",
    "evidence_options",
    "text_action_suggested",
    # Curator-fillable columns. Default workflow:
    #   - decision_evidence_level: pre-filled to the plurality winner; curator
    #     overrides only to dissent-with-the-majority.
    #   - revised_statement: blank by default; curator types corrected wording
    #     when text_action_suggested is non-empty.
    #   - discard: blank by default; curator types TRUE on the rare row where
    #     the claim itself should be removed entirely.
    #   - curator_note: optional rationale.
    "decision_evidence_level",
    "revised_statement",
    "discard",
    "curator_note",
    # Last column — long machine-readable ID; curator can ignore.
    "association_uid",
]


def _section_rank(section: str) -> int:
    return {"needs_curator": 0, "auto_resolved": 1, "no_votes": 2}.get(section, 3)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--tally", type=Path, help="path to tally_<DATE>.json")
    ap.add_argument("--out",   type=Path, help="output worksheet path (.csv)")
    args = ap.parse_args()

    today = date.today().isoformat()
    cycle = _paths.cycle_dir()
    tally_path = args.tally or (cycle / f"tally_{today}.json")
    if not tally_path.exists():
        candidates = sorted(cycle.glob("tally_*.json"))
        if not candidates:
            sys.exit(f"ERROR: tally not found in {cycle}; pass --tally")
        tally_path = candidates[-1]
        print(f"  using latest tally: {tally_path.name}")

    tally = json.loads(tally_path.read_text())
    out_path = args.out or (tally_path.parent / f"adjudication_{today}.csv")

    rows = []
    n_llm_calls = 0
    n_llm_needed = sum(
        1 for e in tally.values()
        if e["n_reviewers"] > 0
        and _text_decision(e["text_tally"])[1]   # text_action_suggested non-empty
    )
    if n_llm_needed:
        print(f"  Generating {n_llm_needed} text revisions via Claude CLI ...")

    for uid, entry in tally.items():
        clf = _classify(entry)
        n_dist, dissent = _contestation(entry["evidence_tally"], entry["curated_evidence"])

        # Pre-fill revised_statement only when text revision is suggested.
        revised = ""
        if clf["section"] == "needs_curator" and clf["text_action_suggested"]:
            n_llm_calls += 1
            print(f"    [{n_llm_calls}/{n_llm_needed}] {uid} ({clf['text_action_suggested']})")
            revised = _llm.suggest_revision(
                original=entry["association_text"],
                direction=clf["text_action_suggested"],
                text_tally=entry["text_tally"],
                evidence_grade=entry["curated_evidence"],
                comments=entry["comments"],
            )

        row = {
            "section":              clf["section"],
            "pmid":                 entry["pmid"],
            "taxon_name":           entry["taxon_name"],
            "association_text":     entry["association_text"],
            "curated_evidence":     entry["curated_evidence"],
            "n_reviewers":          entry["n_reviewers"],
            "evidence_summary":     _summary(entry["evidence_tally"]),
            "text_summary":         _summary(entry["text_tally"]),
            "comments":             " || ".join(entry["comments"]),
            "evidence_options":     clf["evidence_options"],
            "text_action_suggested": clf["text_action_suggested"],
            "decision_evidence_level": clf["decision_evidence_level"],
            "revised_statement":    revised,
            "discard":              "",
            "curator_note":         "",
            "association_uid":      uid,
            # private sort keys (not emitted)
            "_n_dist":              n_dist,
            "_dissent":             dissent,
        }
        rows.append(row)

    # Sort: section, then within needs_curator put the most contested at the
    # top (3-way splits before 2-way splits). Tiebreak by pmid/taxon/uid.
    rows.sort(key=lambda r: (
        _section_rank(r["section"]),
        -r["_n_dist"] if r["section"] == "needs_curator" else 0,
        -r["_dissent"] if r["section"] == "needs_curator" else 0,
        r["pmid"],
        r["taxon_name"],
        r["association_uid"],
    ))
    for r in rows:
        r.pop("_n_dist", None)
        r.pop("_dissent", None)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    # utf-8-sig writes a BOM so Excel/Numbers correctly detect UTF-8 (fixes
    # mojibake on multi-byte characters like en/em dashes and accents).
    with out_path.open("w", newline="", encoding="utf-8-sig") as fh:
        w = csv.DictWriter(fh, fieldnames=COLUMNS, quoting=csv.QUOTE_MINIMAL)
        w.writeheader()
        w.writerows(rows)

    counts = {"needs_curator": 0, "auto_resolved": 0, "no_votes": 0}
    for r in rows:
        counts[r["section"]] = counts.get(r["section"], 0) + 1

    print(f"Wrote adjudication worksheet : {out_path}")
    print()
    print(f"  Total claims               : {len(rows)}")
    print(f"  Needs curator (top of file): {counts['needs_curator']}")
    print(f"  Auto-resolved (KEEP)       : {counts['auto_resolved']}")
    print(f"  No votes received          : {counts['no_votes']}")
    print()
    print("  Open it in Numbers / Excel / Sheets, filter section == 'needs_curator',")
    print("  and fill in the decision_* columns.")


if __name__ == "__main__":
    main()
