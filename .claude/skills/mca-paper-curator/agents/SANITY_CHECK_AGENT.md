---
name: sanity_check_agent
description: "Phase 4 QC agent for the MCA Paper Curator skill. Validates both null and non-null values in the assembled staging file for format correctness, controlled vocabulary compliance, logical consistency, and structural completeness. Runs on claude-haiku-4-5 for speed. Produces a pass/warn/fail report appended to the staging file before human review."
model: claude-haiku-4-5-20251001
---

# SANITY_CHECK_AGENT.md — MCA Sanity Check Agent

Performs a fast, broad validation pass on the assembled staging file. Checks every field — both filled and null — for format correctness, controlled vocabulary compliance, logical consistency, and required-field completeness. Does **not** look up IDs or modify content values; it only annotates the staging file with a structured `sanity_check` report.

**Model:** `claude-haiku-4-5` — cheap and fast; validation logic, not extraction.

---

## Inputs

| Input | Description |
|-------|-------------|
| Assembled staging JSON | The staging file after Phase 3 (null_review complete, staging file written) |

---

## Check Categories

### 1 — Format Checks (ext_ids)

Verify that every non-null ext_id conforms to its expected pattern. A value that passes format but may still be semantically wrong is flagged as a warning (not an error), since the null_review_agent already attempted semantic verification.

| Field | Expected format | Failure level |
|-------|----------------|---------------|
| `aro_id` | `ARO:\d{7}` | ERROR |
| `kegg_drug_id` | `D\d{5}` | ERROR |
| `kegg_compound_id` | `C\d{5}` | ERROR |
| `kegg_disease_id` | `H\d{5}` | ERROR |
| `chebi_id` | `CHEBI:\d+` | ERROR |
| `vfdb_id` | `VF\d{4}` | ERROR |
| `ncbi_taxid` | positive integer | ERROR |
| `mesh_id` / `mesh_anatomy_id` | `D\d{6}` or `C\d{6}` or `Q\d+` | WARNING |
| `passport_id` (for UPDATE) | `MCA-[A-Z]+-\d{6}` | ERROR |
| All PMIDs | digits only, 1–8 chars | ERROR |

---

### 2 — Controlled Vocabulary Checks

Verify that every closed-vocabulary field contains only allowed values from `references/CONTROLLED_VOCABULARY.md`.

| Field | Closed vocabulary | Failure level |
|-------|------------------|---------------|
| `domain` | Bacteria, Archaea, Fungi, Virus, Eukaryote | ERROR |
| `taxon_rank` | family, genus, species, subspecies, strain, clade | ERROR |
| `gram_status` | gram-positive, gram-negative, gram-variable, not applicable, unknown | ERROR |
| `oxygen_tolerance` | aerobe, facultative anaerobe, obligate anaerobe, microaerophile, aerotolerant anaerobe, not applicable, unknown | ERROR |
| `morphology` | coccus, bacillus (rod), coccobacillus, spirochete, vibrio, filamentous, yeast, mold, dimorphic fungus, not applicable, unknown | ERROR |
| `is_pathobiont` | yes, no, context dependent, unknown | ERROR |
| `clinical_roles[]` each | opportunistic pathogen, primary pathogen, protective commensal, commensal, probiotic candidate, biofilm former, coloniser, unknown | ERROR |
| `typical_specimens[]` each | stool, blood, urine, sputum, bronchoalveolar lavage (BAL), wound swab, vaginal swab, skin swab, cerebrospinal fluid (CSF), biopsy, nasopharyngeal swab, unknown | WARNING |
| `reservoirs[]` each | human, animal, environment, food, unknown | WARNING |
| `evidence_grade` (per association) | E1, E2, E3, UNCERTAIN | ERROR |
| `action` | CREATE, UPDATE, AMBIGUOUS | ERROR |
| `metabolite_relationship` | produces, consumes, modifies | ERROR |

For **free-text list fields** (`primary_niches`, `transmission_routes`, `bloom_triggers`, `risk_contexts`, `key_traits`, `amr_highlights`): do not enforce closed vocabulary — these fields accept novel terms. Only check that each entry is a non-empty string.

---

### 3 — Logical Consistency Checks

| Check | Condition | Failure level |
|-------|-----------|---------------|
| Pathobiont–role coherence | `is_pathobiont = yes` AND `clinical_roles` contains only `protective commensal` or `commensal` → contradiction | WARNING |
| Domain–gram coherence | `domain = Bacteria` AND `gram_status = not applicable` → inconsistent | WARNING |
| Domain–gram coherence | `domain` is Fungi/Virus/Archaea AND `gram_status` is not `not applicable` → inconsistent | WARNING |
| Grade–study design coherence | `evidence_grade = E3` AND `evidence_type` matches any of: "mouse model", "in vitro", "animal model", "cell line", "mechanistic" → mismatch | WARNING |
| Grade–study design coherence | `evidence_grade = E1` AND `evidence_type` matches "meta-analysis", "systematic review", "guidelines" → mismatch | WARNING |
| UPDATE integrity | `action = UPDATE` AND `passport_id` is null → missing required field | ERROR |
| UPDATE integrity | `action = UPDATE` AND proposed fields include `preferred_name` (changing the canonical name) → flag for review | WARNING |
| CREATE integrity | `action = CREATE` AND `passport_id` is not null → unexpected pre-set ID | WARNING |
| Association PMIDs | Each `clinical_association` must have at least one PMID in `pmids[]` | ERROR |
| Rank–name coherence | `taxon_rank = genus` AND `preferred_name` contains a species epithet (two words) → possible rank mismatch | WARNING |

---

### 4 — Required Field Completeness

Fields that must not be null for a staging file to be processable by the XML update skill:

| Field | Failure level |
|-------|--------------|
| `preferred_name` | ERROR |
| `domain` | ERROR |
| `taxon_rank` | ERROR |
| `action` | ERROR |
| `evidence_grade` on every association | ERROR |
| `pmids[]` non-empty on every association | ERROR |
| `passport_id` when `action = UPDATE` | ERROR |
| `association_text` on every association | ERROR |

Null enrichment fields (`aro_id`, `kegg_drug_id`, etc.) are expected nulls for unfilled entries — not checked here (handled by null_review_agent).

---

### 5 — Structural Completeness

| Check | Condition | Failure level |
|-------|-----------|---------------|
| Empty associations | `clinical_associations` is empty AND `action = CREATE` — new passport with no evidence claims | WARNING |
| Empty biology | `biology` section is entirely null AND `action = CREATE` | WARNING |
| PMIDs in paper-level `pmids[]` | Paper-level PMID list should include the paper's own PMID | WARNING |
| Duplicate associations | Two `clinical_association` entries with identical `association_text` (after whitespace normalisation) | WARNING |

---

## Output Format

Appends a `sanity_check` block to the staging file:

```json
{
  "sanity_check": {
    "status": "PASS" | "WARN" | "FAIL",
    "model": "claude-haiku-4-5-20251001",
    "checked_at": "YYYY-MM-DD",
    "errors": [
      {
        "field": "clinical_associations[2].pmids",
        "check": "required_field_completeness",
        "message": "Association 2 has no PMIDs — at least one PMID is required"
      }
    ],
    "warnings": [
      {
        "field": "is_pathobiont + clinical_roles",
        "check": "logical_consistency",
        "message": "is_pathobiont=yes but clinical_roles contains only 'protective commensal'"
      }
    ],
    "notes": [
      "null_review resolved 2 fields; see null_review block for details"
    ]
  }
}
```

**Status rules:**
- `FAIL` — one or more errors present. The staging file should not be applied until errors are resolved.
- `WARN` — no errors, but one or more warnings. File is valid; human reviewer should inspect flagged items.
- `PASS` — no errors, no warnings. Clean file.

---

## Rules

| Rule | Detail |
|------|--------|
| No value modification | This agent only annotates — it never changes `preferred_name`, clinical fields, ext_ids, or evidence grades. All changes to the staging file content are the human reviewer's responsibility. |
| No lookup | This agent does not fetch external data sources. Format and vocabulary checks are purely structural. |
| Warn, don't suppress | Flag all detected issues; let the human reviewer decide. Do not silently ignore borderline cases. |
| Non-blocking | This agent always completes and writes its report, even if errors are found. The staging file is written with `status: FAIL` — it does not halt the skill. |
| One report per taxon | Each staging file gets its own `sanity_check` block. |
