---
name: paper_analyst_agent
description: "Phase 0 agent for the MCA Paper Curator skill. Reads a research paper PDF, extracts paper metadata, identifies all taxa mentioned, and writes the summary directly into the staging file. No user confirmation — the skill runs end-to-end."
model: claude-opus-4-6
model_rationale: "Opus is used here because this agent reads the full PDF, and its taxon identification and abstract extraction outputs set the scope for every downstream agent. A missed taxon produces no staging file — there is no downstream recovery path. This is a single call per paper, so the cost is bounded."
---

# PAPER_ANALYST_AGENT.md — MCA Paper Analyst Agent

Reads the full PDF of a research paper and extracts structured metadata. Identifies all microbial taxa mentioned in the paper. Returns structured output to the orchestrator — **no user confirmation required**. The skill runs end-to-end; the user reviews the final staging file.

---

## Inputs

| Input | Description |
|-------|-------------|
| PDF file | The research paper provided by the user. The filename stem (without `.pdf`) is the PMID — it has already been validated as digits-only by the pre-phase check before this agent runs. |
| Current XML | Most recent `database/MCA_DB_*.xml` file — used for the cross-check step (Step 6). Use the highest-versioned file present. |

---

## Task

1. Read the full PDF
2. Set `pmid` from the filename stem — do **not** search the PDF text for the PMID
3. Extract remaining paper metadata (fields below)
4. Identify all microbial taxa mentioned in the paper
5. Flag any uncertainties
6. **Cross-check**: collect all `preferred_name` and `synonym` values from every passport in the current XML. Scan the paper's main text (Introduction, Results, Discussion) for any of those names. For each XML name found in the paper text that is **not** in the confirmed taxa list, add a `cross_check_flags` entry — it may represent a Phase 0 omission for human review.
7. Return structured output

---

## Output Fields

### Paper Metadata

| Field | Description |
|-------|-------------|
| `pmid` | PubMed ID — taken directly from the PDF filename stem (already validated); do not search the PDF text for this value |
| `title` | Full paper title |
| `abstract` | Full abstract text, copied verbatim from the paper. If no structured abstract is present, copy the opening summary paragraph. Never truncate. |
| `authors` | Author list (Last FM format, semicolon-separated) |
| `journal` | Journal name |
| `year` | Publication year |
| `study_design` | Study design type (e.g., "prospective cohort", "RCT", "systematic review", "mouse model", "in vitro") |
| `population` | Study population description (e.g., "312 adult IBD patients", "C57BL/6 mice", "healthy volunteers") |
| `sample_size` | Reported sample size; `null` if not stated |

### Taxa Identified

List all microbial taxa that are **explicitly characterized in the main text** (Introduction, Results, Discussion, or clinical data tables) where the paper assigns at least one of the following:
- A clinical role (e.g., pathobiont, commensal, protective)
- A clinical association or outcome
- A biological or ecological feature
- A quantitative measurement or statistical result

Mark each taxon with `is_primary_focus: true` if it is a central subject of analysis (dedicated figures, statistics, or mechanistic discussion), or `false` if mentioned in passing (e.g., named once as a co-occurring organism, comparison taxon, or single-sentence characterization).

**Exclude** taxa that appear only in:
- Methods sections (as sequencing references or reagents)
- Reference citation contexts (mentioned as findings of prior studies, not this paper)
- Figure axis labels or legend keys without a corresponding main-text characterization
- Supplementary tables without a supporting main-text claim

**Include** taxa mentioned in passing in Results or Discussion **if** the paper assigns them a clinical role or ecological characterization — even in a single sentence (e.g., *"emergence of pathobiont taxa (Enterococcaceae and Enterobacteriaceae)"* qualifies both taxa for inclusion).

For each taxon:

| Field | Description |
|-------|-------------|
| `name_in_paper` | Exact name as written in the paper |
| `preferred_name` | Standardized name (resolve to current valid nomenclature if possible) |
| `taxon_rank` | Inferred rank — must be one of the controlled values: `family`, `genus`, `species`, `strain`, `clade`. If the taxon is at order, class, or phylum level (not in the CV), set `taxon_rank: null` and flag in `flags[]`. |
| `ncbi_taxid` | NCBI TaxID if determinable; `null` otherwise |
| `is_primary_focus` | `true` if the taxon is a central subject of analysis; `false` if mentioned in passing but still qualifies for inclusion |

---

## Output Format

```json
{
  "paper": {
    "pmid": "",
    "title": "",
    "abstract": "",
    "authors": "",
    "journal": "",
    "year": "",
    "study_design": "",
    "population": "",
    "sample_size": null
  },
  "taxa_identified": [
    {
      "name_in_paper": "",
      "preferred_name": "",
      "taxon_rank": "family | genus | species | strain | clade | null",
      "ncbi_taxid": null,
      "is_primary_focus": true
    }
  ],
  "cross_check_flags": [
    {
      "xml_name": "",
      "passport_id": "MCA-BAC-000000 | null",
      "reason": "Name found in paper main text but not in confirmed taxa list — possible omission"
    }
  ],
  "flags": []
}
```

---

## Flagging Rules

Populate `flags` with plain-text notes when:
- Study design is ambiguous or not explicitly stated
- A taxon name is outdated, misspelled, or ambiguous (e.g., genus-level vs species-level)
- The paper is a preprint or conference abstract
- Sample size is not reported

---

## Output Handoff

Return the structured JSON output to the orchestrator. Do not ask the user to confirm. The orchestrator passes this output directly to Phase 1 agents.
