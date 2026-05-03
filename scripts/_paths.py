"""Path helpers for the review-cycle pipeline.

All review artifacts (tokens, votes, tally, adjudication CSV, resolved
staging files, LLM suggestion cache, curator notes) live under a single
Dropbox-synced directory tree:

    ~/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/review_cycles/
    └── cycle_<YYYY-MM-DD>/         <-- active cycle (one per review round)
        ├── tokens.md
        ├── votes_<DATE>.csv
        ├── tally_<DATE>.json
        ├── context_comments_<DATE>.json
        ├── adjudication_<DATE>.csv
        ├── resolved_staging/*.json
        ├── .llm_cache/<sha256>.txt
        └── notes.md

The Dropbox folder is the **immutable per-cycle audit record** — never
modified after the cycle closes. Files for the next cycle land in a
sibling cycle_<DATE>/ folder.

Override the active dir via the MCA_REVIEW_CYCLE_DIR env var (use an
absolute path) — useful when re-running an old cycle for backfill or
when testing in docker against a synthetic cycle.
"""

import os
from datetime import date
from pathlib import Path

DROPBOX_REVIEW_CYCLES = Path(os.path.expanduser(
    "~/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/review_cycles"
))


def cycle_dir(*, create: bool = True) -> Path:
    """Return the active review-cycle directory.

    Defaults to ~/.../review_cycles/cycle_<TODAY>/.
    Override via MCA_REVIEW_CYCLE_DIR env var (absolute path).
    """
    override = os.environ.get("MCA_REVIEW_CYCLE_DIR")
    if override:
        p = Path(os.path.expanduser(override))
    else:
        p = DROPBOX_REVIEW_CYCLES / f"cycle_{date.today().isoformat()}"
    if create:
        p.mkdir(parents=True, exist_ok=True)
    return p


def llm_cache_dir(*, create: bool = True) -> Path:
    """Per-cycle LLM suggestion cache."""
    p = cycle_dir(create=create) / ".llm_cache"
    if create:
        p.mkdir(parents=True, exist_ok=True)
    return p


def find_existing_cycle_artifact(prefix: str) -> Path | None:
    """Locate the most recent file in the active cycle dir matching prefix.

    Used by scripts that want to find the latest tally / adjudication
    CSV without forcing the curator to retype the date.
    """
    cd = cycle_dir(create=False)
    if not cd.is_dir():
        return None
    matches = sorted(cd.glob(f"{prefix}_*.*"))
    return matches[-1] if matches else None
