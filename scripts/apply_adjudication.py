#!/usr/bin/env python3
"""apply_adjudication.py — apply curator decisions to staging files.

Reads the completed adjudication CSV (from build_adjudication.py +
curator edits) and overlays each row's decision onto the matching
clinical_association in the original staging JSON. Writes resolved
staging files to <cycle_dir>/resolved_staging/.

(cycle_dir defaults to Dropbox: ~/.../mca/review_cycles/cycle_<TODAY>/;
override with MCA_REVIEW_CYCLE_DIR env var.)

For each row:
  discard == TRUE                            -> drop this claim
  decision_evidence_level differs from orig  -> regrade evidence_level
  revised_statement non-empty                -> replace association_text
  otherwise                                  -> kept as-is

UNDETERMINED in decision_evidence_level is mapped to UNCERTAIN, the
value the staging schema uses (and the value xml2sql.py filters out
of the SQL dump).

The resolved files are the input for mca-xml-update on the v1.11 cut.

Usage (run from repo root):
    python3 scripts/apply_adjudication.py
        [--csv <cycle_dir>/adjudication_<DATE>.csv]
        [--out <cycle_dir>/resolved_staging/]
        [--dry-run]
"""

import argparse
import csv
import json
import sys
from collections import defaultdict
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _paths  # noqa: E402

STAGING_DIR = Path(__file__).resolve().parent.parent / "review_data" / "staging"

# Valid values for the curator-fillable enum-style columns.
VALID_GRADES = {"E1", "E2", "E3", "UNDETERMINED", "UNCERTAIN"}
VALID_DISCARD = {"", "TRUE"}
VALID_SECTIONS = {"needs_curator", "auto_resolved", "no_votes"}


def _normalize_grade(grade: str) -> str:
    g = (grade or "").strip()
    if g == "UNDETERMINED":
        return "UNCERTAIN"
    return g


def _validate_rows(rows: list) -> list[str]:
    """Return a list of human-readable error strings; empty means the CSV is OK."""
    errors: list[str] = []
    for r in rows:
        uid = r.get("association_uid", "<unknown_uid>")
        section = (r.get("section") or "").strip()
        grade = (r.get("decision_evidence_level") or "").strip()
        discard = (r.get("discard") or "").strip().upper()

        if section not in VALID_SECTIONS:
            errors.append(f"{uid}: unrecognized section {section!r}")

        if section == "needs_curator" and discard != "TRUE" and not grade:
            errors.append(
                f"{uid}: needs_curator row has blank decision_evidence_level "
                f"(curator must pick one of: {r.get('evidence_options') or '?'})"
            )

        if grade and grade not in VALID_GRADES:
            errors.append(
                f"{uid}: decision_evidence_level={grade!r} is not one of "
                f"{sorted(VALID_GRADES)}"
            )

        if discard and discard not in VALID_DISCARD:
            errors.append(
                f"{uid}: discard={r.get('discard')!r} — must be blank or TRUE"
            )
    return errors


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--csv", type=Path, help="path to adjudication_<DATE>.csv")
    ap.add_argument("--out", type=Path, default=None,
                    help="output dir (default: <cycle_dir>/resolved_staging/)")
    ap.add_argument("--dry-run", action="store_true", help="don't write files")
    ap.add_argument("--force", action="store_true",
                    help="proceed even if the CSV has validation errors")
    args = ap.parse_args()

    today = date.today().isoformat()
    cycle = _paths.cycle_dir()
    csv_path = args.csv or (cycle / f"adjudication_{today}.csv")
    if not csv_path.exists():
        candidates = sorted(cycle.glob("adjudication_*.csv"))
        if not candidates:
            sys.exit(f"ERROR: adjudication CSV not found in {cycle}")
        csv_path = candidates[-1]
        print(f"  using latest CSV: {csv_path.name}")
    out_dir = args.out if args.out else (cycle / "resolved_staging")

    if not STAGING_DIR.is_dir():
        sys.exit(f"ERROR: original staging dir missing: {STAGING_DIR}")

    with csv_path.open(encoding="utf-8-sig") as fh:
        rows = list(csv.DictReader(fh))

    errors = _validate_rows(rows)
    if errors:
        print(f"Validation found {len(errors)} issue(s) in {csv_path.name}:",
              file=sys.stderr)
        for e in errors:
            print(f"  ✗ {e}", file=sys.stderr)
        if not args.force:
            print("\nRefusing to write resolved staging files. Fix the CSV "
                  "and re-run, or pass --force to proceed anyway.",
                  file=sys.stderr)
            sys.exit(2)
        print("\n--force passed; proceeding despite the issues above.\n",
              file=sys.stderr)

    # Group rows by staging file stem. association_uid format:
    # "<staging_filename_no_ext>__<idx>"  e.g. "2026-04-03_alistipes-indistinctus__0"
    by_file: dict[str, list] = defaultdict(list)
    for r in rows:
        uid = r.get("association_uid", "")
        if "__" not in uid:
            continue
        stem, idx_str = uid.rsplit("__", 1)
        try:
            r["_idx"] = int(idx_str)
        except ValueError:
            continue
        by_file[stem].append(r)

    if not args.dry_run:
        out_dir.mkdir(parents=True, exist_ok=True)

    n_files = n_files_changed = 0
    n_kept = n_regrade = n_revise = n_both = n_discard = n_no_op = 0

    for stem, file_rows in sorted(by_file.items()):
        src = STAGING_DIR / f"{stem}.json"
        if not src.exists():
            print(f"  ! no staging file for {stem}; skipping")
            continue
        n_files += 1

        staging = json.loads(src.read_text())
        cas = (staging.get("proposed_changes") or {}).get("clinical_associations") or []
        rows_by_idx = {r["_idx"]: r for r in file_rows}

        new_cas = []
        file_changed = False
        for idx, ca in enumerate(cas):
            r = rows_by_idx.get(idx)
            if not r:
                # Shouldn't happen — every claim in tally => row in CSV
                new_cas.append(ca)
                n_no_op += 1
                continue

            if r.get("discard", "").strip().upper() == "TRUE":
                n_discard += 1
                file_changed = True
                continue  # drop the claim

            new_ca = dict(ca)
            grade_change = False
            text_change = False

            new_grade = _normalize_grade(r.get("decision_evidence_level", ""))
            if new_grade and new_grade != ca.get("evidence_level"):
                new_ca["evidence_level"] = new_grade
                grade_change = True

            new_text = (r.get("revised_statement") or "").strip()
            if new_text and new_text != (ca.get("association_text") or "").strip():
                new_ca["association_text"] = new_text
                text_change = True

            if grade_change and text_change:
                n_both += 1
                file_changed = True
            elif grade_change:
                n_regrade += 1
                file_changed = True
            elif text_change:
                n_revise += 1
                file_changed = True
            else:
                n_kept += 1

            new_cas.append(new_ca)

        staging.setdefault("proposed_changes", {})["clinical_associations"] = new_cas

        if file_changed:
            n_files_changed += 1

        if not args.dry_run:
            (out_dir / f"{stem}.json").write_text(
                json.dumps(staging, indent=2, ensure_ascii=False)
            )

    print()
    print(f"Source CSV                       : {csv_path.name}")
    print(f"Original staging dir             : {STAGING_DIR}")
    print(f"Resolved staging dir             : {out_dir}{' (dry run)' if args.dry_run else ''}")
    print()
    print(f"Staging files processed          : {n_files}")
    print(f"Files with at least one change   : {n_files_changed}")
    print()
    print(f"Claims kept as-is                : {n_kept}")
    print(f"Claims regraded                  : {n_regrade}")
    print(f"Claims with text revised         : {n_revise}")
    print(f"Claims with both regrade + revise: {n_both}")
    print(f"Claims discarded                 : {n_discard}")
    if n_no_op:
        print(f"Claims with no matching CSV row  : {n_no_op}")


if __name__ == "__main__":
    main()
