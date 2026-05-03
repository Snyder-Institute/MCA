"""Claude-CLI wrapper for one-shot text revision.

Uses the user's local Claude Code CLI (`claude -p`) under their existing
Max subscription — no Anthropic API key required. Each suggestion is
cached on disk keyed on the prompt's SHA-256 so re-running
build_adjudication.py costs nothing on subsequent runs.

Failure modes (CLI missing, non-zero exit, timeout) fall back to
returning the original text and printing a warning. The worksheet
still builds.
"""

import hashlib
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _paths  # noqa: E402

# The user's global CLAUDE.md mandates a leading mode marker on every reply
# (e.g. "<ask before edits>"). Strip it from CLI output before returning.
_MODE_PREFIX = re.compile(r"^\s*<[^>\n]+>\s*\n+", re.MULTILINE)

CLI_TIMEOUT = 90  # seconds; one short rewrite is well under this
MODEL = "opus"

SYSTEM_PROMPT = """\
You revise curated biomedical clinical-association statements based on \
independent-reviewer feedback. The original statement was extracted from a \
research paper by another agent; reviewers have voted that the wording is too \
weak (understated), too strong (overstated), or in mixed disagreement.

When you rewrite:
1. Preserve every numeric finding verbatim — cohort sizes, p-values, hazard \
ratios, effect sizes, odds ratios, percentages, sample counts.
2. Match the requested direction, but never introduce causal language \
unsupported by the original. "Associated with" stays "associated with" unless \
the paper itself established causation.
3. Stay in the same neutral biomedical-curation register — third person, \
factual, no hedging adverbs unless they're already there.
4. Keep the length within ±20% of the original.

Output ONLY the revised statement. No preamble. No explanation. No quotation \
marks. No leading or trailing whitespace.
"""


def _build_prompt(original: str, direction: str, text_tally: dict,
                  evidence_grade: str, comments: list) -> str:
    tally_compact = " ".join(f"{k}:{v}" for k, v in text_tally.items() if v)
    comments_str = " || ".join(comments) if comments else "(none)"
    user = (
        f"DIRECTION: {direction}\n"
        f"TALLY: {tally_compact or '(none)'}\n"
        f"EVIDENCE_GRADE: {evidence_grade}\n"
        f"ORIGINAL:\n{original}\n\n"
        f"REVIEWER COMMENTS:\n{comments_str}"
    )
    return f"{SYSTEM_PROMPT}\n---\n\n{user}"


def _cache_path(prompt: str) -> Path:
    h = hashlib.sha256(prompt.encode("utf-8")).hexdigest()
    return _paths.llm_cache_dir() / f"{h}.txt"


def suggest_revision(original: str, direction: str, text_tally: dict,
                     evidence_grade: str, comments: list) -> str:
    """Return an LLM-rewritten version of the original statement.

    Falls back to the original on any failure (CLI missing, non-zero
    exit, timeout, empty output).
    """
    prompt = _build_prompt(original, direction, text_tally, evidence_grade, comments)
    cache = _cache_path(prompt)
    if cache.exists():
        return cache.read_text(encoding="utf-8").strip()

    try:
        result = subprocess.run(
            [
                "claude", "-p",
                "--model", MODEL,
                "--output-format", "text",
                "--allowedTools", "none",
            ],
            input=prompt,
            capture_output=True,
            text=True,
            timeout=CLI_TIMEOUT,
        )
    except FileNotFoundError:
        print("  ! `claude` CLI not found in PATH; skipping LLM suggestions.",
              file=sys.stderr)
        return original
    except subprocess.TimeoutExpired:
        print(f"  ! `claude -p` timed out (>{CLI_TIMEOUT}s); using original.",
              file=sys.stderr)
        return original

    if result.returncode != 0:
        print(f"  ! `claude -p` exited {result.returncode}; using original.",
              file=sys.stderr)
        if result.stderr:
            print(f"    stderr: {result.stderr.strip()[:200]}", file=sys.stderr)
        return original

    raw = result.stdout
    # Strip mandated mode-prefix lines like "<ask before edits>".
    raw = _MODE_PREFIX.sub("", raw, count=1)
    suggestion = raw.strip()
    if not suggestion:
        print("  ! `claude -p` returned empty output; using original.",
              file=sys.stderr)
        return original

    cache.parent.mkdir(parents=True, exist_ok=True)
    cache.write_text(suggestion, encoding="utf-8")
    return suggestion
