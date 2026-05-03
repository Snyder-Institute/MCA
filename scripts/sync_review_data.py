#!/usr/bin/env python3
"""sync_review_data.py — copy Dropbox staging JSONs and PDFs into review_data/.

Source (Dropbox, read-only):
    ~/.../mca/staged/*.json
    ~/.../mca/pdfs/00000000/<PMID>.pdf

Destination (gitignored):
    MCA/review_data/staging/*.json
    MCA/review_data/pdfs/<PMID>.pdf

Idempotent — skips files whose mtime+size already match destination.
Pass --force to overwrite unconditionally.

Usage (run from repo root):
    python3 scripts/sync_review_data.py
    python3 scripts/sync_review_data.py --force
"""

import argparse
import os
import shutil
import sys
from pathlib import Path

DROPBOX_BASE = Path(os.path.expanduser(
    "~/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca"
))
SRC_STAGING = DROPBOX_BASE / "staged"
SRC_PDFS    = DROPBOX_BASE / "pdfs" / "00000000"

DEST_BASE   = Path(__file__).resolve().parent.parent / "review_data"
DEST_STAGING = DEST_BASE / "staging"
DEST_PDFS   = DEST_BASE / "pdfs"


def _needs_copy(src: Path, dst: Path, force: bool) -> bool:
    if force or not dst.exists():
        return True
    src_st, dst_st = src.stat(), dst.stat()
    return src_st.st_size != dst_st.st_size or src_st.st_mtime > dst_st.st_mtime


def _sync_dir(src_dir: Path, dst_dir: Path, glob: str, force: bool) -> tuple[int, int]:
    if not src_dir.is_dir():
        sys.exit(f"ERROR: source directory missing: {src_dir}")
    dst_dir.mkdir(parents=True, exist_ok=True)
    copied = skipped = 0
    for src in sorted(src_dir.glob(glob)):
        dst = dst_dir / src.name
        if _needs_copy(src, dst, force):
            shutil.copy2(src, dst)
            copied += 1
        else:
            skipped += 1
    return copied, skipped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--force", action="store_true", help="overwrite unchanged files")
    args = ap.parse_args()

    print(f"Source : {DROPBOX_BASE}")
    print(f"Target : {DEST_BASE}")
    print()

    s_copied, s_skipped = _sync_dir(SRC_STAGING, DEST_STAGING, "*.json", args.force)
    print(f"  staging JSONs : copied {s_copied:3d}  skipped {s_skipped:3d}")

    p_copied, p_skipped = _sync_dir(SRC_PDFS, DEST_PDFS, "*.pdf", args.force)
    print(f"  PDFs          : copied {p_copied:3d}  skipped {p_skipped:3d}")


if __name__ == "__main__":
    main()
