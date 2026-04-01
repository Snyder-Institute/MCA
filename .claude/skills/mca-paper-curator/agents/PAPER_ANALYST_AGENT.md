---
name: paper_analyst_agent
description: "Phase 0 agent for the MCA Paper Curator skill. Reads a research paper PDF, extracts paper metadata, identifies all taxa mentioned, and writes the summary directly into the staging file. No user confirmation — the skill runs end-to-end."
---

# PAPER_ANALYST_AGENT.md — MCA Paper Analyst Agent

Reads the full PDF of a research paper and extracts structured metadata. Identifies all microbial taxa mentioned in the paper. Returns structured output to the orchestrator — **no user confirmation required**. The skill runs end-to-end; the user reviews the final staging file.

---

## Inputs

| Input | Description |
|-------|-------------|
| PDF file | The research paper provided by the user. The filename stem (without `.pdf`) is the PMID — it has already been validated as digits-only by the pre-phase check before this agent runs. |

---

## Task

1. Read the full PDF
2. Set `pmid` from the filename stem — do **not** search the PDF text for the PMID
3. Extract remaining paper metadata (fields below)
4. Identify all microbial taxa mentioned in the paper
5. Flag any uncertainties
6. Return structured output for user confirmation

---

## Output Fields

### Paper Metadata

| Field | Description |
|-------|-------------|
| `pmid` | PubMed ID — taken directly from the PDF filename stem (already validated); do not search the PDF text for this value |
| `title` | Full paper title |
| `authors` | Author list (Last FM format, semicolon-separated) |
| `journal` | Journal name |
| `year` | Publication year |
| `study_design` | Study design type (e.g., "prospective cohort", "RCT", "systematic review", "mouse model", "in vitro") |
| `population` | Study population description (e.g., "312 adult IBD patients", "C57BL/6 mice", "healthy volunteers") |
| `sample_size` | Reported sample size; `null` if not stated |

### Taxa Identified

List all microbial taxa mentioned in the paper — including those that are the primary focus and those mentioned incidentally. For each taxon:

| Field | Description |
|-------|-------------|
| `name_in_paper` | Exact name as written in the paper |
| `preferred_name` | Standardized name (resolve to current valid nomenclature if possible) |
| `taxon_rank` | Inferred rank (species, genus, family, etc.) |
| `ncbi_taxid` | NCBI TaxID if determinable; `null` otherwise |
| `is_primary_focus` | `true` if the taxon is a primary subject of the paper; `false` if mentioned incidentally |

---

## Output Format

```json
{
  "paper": {
    "pmid": "",
    "title": "",
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
      "taxon_rank": "",
      "ncbi_taxid": null,
      "is_primary_focus": true
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
