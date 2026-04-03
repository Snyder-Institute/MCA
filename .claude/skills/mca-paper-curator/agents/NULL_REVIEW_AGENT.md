---
name: null_review_agent
description: "Phase 3 QC agent for the MCA Paper Curator skill. Re-attempts all null ext_id fields in the merged staging output using alternative search strategies and web fallbacks. Classifies each null as confirmed_null, filled, or needs_review before the staging file is written."
---

# NULL_REVIEW_AGENT.md — MCA Null Review Agent

Audits every null ext_id field in the merged staging output and determines whether each null is genuinely unfillable or a missed lookup from Phase 2 enrichment agents. Runs as the final step of Phase 3, before the staging file is written.

**Scope:** null ext_ids only — does not modify text values, clinical judgements, or evidence grades.

> **Maintenance note:** This agent mirrors the lookup logic of Phase 2 enrichment agents with extended fallback strategies. When a Phase 2 agent's matching rules change, the corresponding section below must be updated in parallel to stay consistent.

---

## Inputs

| Input | Description |
|-------|-------------|
| Merged staging object | The Phase 2–merged object per taxon — after all enrichment agents have run but before staging file is written |
| Local data source paths | KEGG mirror path (from project memory `reference_kegg_path.md`), VFDB JSON path (from `reference_vfdb_path.md`), ARO index path (from `reference_aro_path.md`), ChEBI index path (from `reference_chebi_path.md`), NCBI names index path (from `reference_ncbi_path.md`) — resolved by orchestrator and passed explicitly |

---

## Fields Reviewed

| Field | Source agent | Re-attempt strategy |
|-------|-------------|---------------------|
| `amr_highlights[].aro_id` | aro_agent | ARO index (local); alternative normalisation; confirmed mapping table |
| `bloom_triggers[].kegg_drug_id` | kegg_agent | Known-null class check first; specific drug extraction; KEGG Drug flat file |
| `metabolites[].kegg_compound_id` | kegg_agent | KEGG Compound flat file with aliases; abbreviation expansion |
| `metabolites[].chebi_id` | (not enriched in Phase 2) | Local ChEBI index; ChEBI REST API fallback |
| `clinical_associations[].assoc_refs` (missing kegg_disease) | kegg_agent | KEGG Disease flat file with alternate condition phrasing; abbreviation expansion |
| `clinical_associations[].assoc_refs` (missing mesh) | mesh_agent | NLM E-utilities: `https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5` |
| `virulence_factors[].vfdb_id` | vfdb_agent | Local vfdb.json; partial VF name match; VFDB name normalisation |
| `primary_niches[].mesh_anatomy_id` | mesh_agent / db_fetch_agent | NLM anatomy lookup (already attempted in Phase 2 pre-fetch; re-attempt with synonym) |
| `typical_specimens[].mesh_anatomy_id` | mesh_agent | NLM anatomy lookup with alternate term |
| `identity.ncbi_taxid` | db_fetch_agent | Local NCBI names index; NCBI Taxonomy Esearch fallback |

---

## Classification Tags

Each null field is assigned one of three tags:

| Tag | Meaning | Effect on staging file |
|-----|---------|----------------------|
| `confirmed_null` | Genuinely unfillable — sentinel value, known-null class, or no match after re-attempt | Keep null; record reason in `null_review` block |
| `filled` | A match was found that Phase 2 missed | Update the field with the resolved ID; record in `null_review` block |
| `needs_review` | A candidate was found but confidence is insufficient to auto-fill | Keep null; record candidate(s) in `null_review` block for human review |

---

## Re-Attempt Logic Per Field

### `aro_id`
> **Mirrors:** `aro_agent` (ARO_AGENT.md) — same index, extended normalisation

1. **Skip immediately** (→ `confirmed_null`):
   - Value is `none documented` or `unknown`
   - Value contains `intrinsic glycopeptide resistance`, `intrinsic vancomycin resistance`, or similar structural insensitivity phrasing — no ARO phenotype term exists for commensals
2. Load local `aro_index.json` (path from `reference_aro_path.md`); try confirmed mapping table (MDR → ARO:3004305, VRE → ARO:3004329)
3. Try with alternative normalisations: strip parentheticals, expand all abbreviations from the ARO_AGENT abbreviation table
4. If still null → `confirmed_null: no_match_in_aro_index`

### `kegg_drug_id`
> **Mirrors:** `kegg_agent` Task 3 (KEGG_AGENT.md) — same flat file, same known-null class list

1. **Skip immediately** (→ `confirmed_null`) for known-null class terms:
   `antibiotic exposure`, `immunosuppression`, `inflammation`, `dietary change`, `dysbiosis`, `hospitalization`, `surgery`, `chemotherapy`, `proton pump inhibitor (PPI) use`, `unknown`
2. For other terms: extract specific drug name; try KEGG Drug flat file with INN/USAN aliases
3. If still null → `confirmed_null: no_kegg_drug_entry`

### `kegg_compound_id`
> **Mirrors:** `kegg_agent` Task 4 (KEGG_AGENT.md) — same flat file, extended alias expansion

1. Try KEGG Compound flat file with:
   - Original `metabolite_name`
   - Common aliases (e.g., `butyric acid` → `butyrate`, `4-hydroxybutyrate`)
   - Abbreviation expansion (TMAO → trimethylamine N-oxide; SCFA → skip, drug class)
2. If still null → `confirmed_null: no_kegg_compound_entry` (or `confirmed_null: drug_class`)

### `chebi_id`
> **First enriched here** — no Phase 2 agent attempts this field

1. Load local `chebi_lite_index.json` (path from `reference_chebi_path.md`, passed by orchestrator).
   - Format: `{chebi_id → {name: str, synonyms: [str, ...]}}`
   - 205,170 manually curated entries (equivalent to `entityStar ≥ 2`)
   - Build reverse lookup: `{lowercase_name → chebi_id}`
2. Attempt exact → alias → partial match against local index.
3. If no local match: fall back to ChEBI REST API: `https://www.ebi.ac.uk/webservices/chebi/2.0/getLiteEntity?search={name}&searchCategory=ALL&maximumResults=5`
   - Parse XML; extract `chebiId` from `ListElement` where `entityStar ≥ 2`
   - Prefer `entityStar=3`; flag `needs_review` if ambiguous
4. If no result → `confirmed_null: no_chebi_entry`

### `kegg_disease_id` (on association assoc_refs)
> **Mirrors:** `kegg_agent` Task 2 (KEGG_AGENT.md) — same flat file, extended phrasing and abbreviations

1. Extract condition from `association_text` (same logic as kegg_agent)
2. Re-attempt KEGG Disease flat file lookup with:
   - Full condition name
   - Abbreviation expansions: CDI, IBD, IBS, CRC, T2D, T2DM, UC, CD (Crohn's), GERD
   - Shorter/alternate phrasing (e.g., remove qualifiers like "recurrent", "pediatric")
3. **When a match is found: always populate `ref_label` with the canonical disease name from the flat file (first NAME alias, original case) at the same time as `ref_id`.** Never write a `kegg_disease_id` without its `ref_label` — a bare ID is not human-readable.
4. If still null → `confirmed_null: no_kegg_disease_entry`

### `mesh_id` (on clinical associations)
> **Mirrors:** `mesh_agent` Task 1 (MESH_AGENT.md) — same NLM endpoint, alternate term phrasing

1. Extract condition term from `association_text`
2. WebFetch NLM descriptor lookup: `https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5`
3. If multiple hits: prefer exact or higher-relevance match; flag `needs_review` if ambiguous
4. If still null → `confirmed_null: no_mesh_descriptor`

### `vfdb_id`
> **Mirrors:** `vfdb_agent` (VFDB_AGENT.md) — same vfdb.json, extended partial matching

1. Check if the organism's preferred_name is in the `MCA_VFDB_MAP` (covered organisms: see VFDB_AGENT.md)
2. If organism not in VFDB coverage → `confirmed_null: organism_not_in_vfdb`
3. If organism is covered: try matching `vf_name` from vfdb.json to the staging `value` using:
   - Exact match (case-insensitive)
   - Partial match (value is substring of vf_name or vice versa)
4. If no match → `confirmed_null: vf_name_not_in_vfdb` (log the unmatched name for human review)

### `ncbi_taxid`
> **Mirrors:** `db_fetch_agent` fallback (DB_FETCH_AGENT.md) — same local index and API endpoint

1. **Local index first** — load `ncbi_names_index.json` (path from `reference_ncbi_path.md`, passed by orchestrator). Look up `preferred_name` directly (2.7M scientific names → taxid).
   - If found: fill with the TaxID → `filled`
2. **API fallback** — if not found locally: WebFetch NCBI Esearch: `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=taxonomy&term={preferred_name}[Scientific Name]&retmode=json`
   - If exactly one result: fill with the TaxID → `filled`
   - If multiple results or zero: → `needs_review` (list candidates) or `confirmed_null: name_ambiguous`

### `mesh_anatomy_id` (niches and specimens)
> **Mirrors:** `mesh_agent` Task 2 (MESH_AGENT.md) — same NLM endpoint, extended synonym expansion

1. WebFetch NLM anatomy lookup: `https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5`
2. Try controlled vocabulary synonyms (e.g., `gut` → `intestine`, `large intestine`)
3. If still null → `confirmed_null: no_mesh_anatomy_match`

---

## Output Format

Annotates the staging object with a `null_review` block per taxon:

```json
{
  "null_review": {
    "status": "clean" | "filled" | "needs_review",
    "findings": [
      {
        "field": "amr_highlights[0].aro_id",
        "value": "multidrug-resistant (MDR)",
        "tag": "filled",
        "resolved_id": "ARO:3004305",
        "method": "confirmed_mapping_table",
        "note": null
      },
      {
        "field": "bloom_triggers[1].kegg_drug_id",
        "value": "antibiotic exposure",
        "tag": "confirmed_null",
        "resolved_id": null,
        "method": "known_null_class",
        "note": "Drug class term — no KEGG Drug D-number"
      },
      {
        "field": "metabolites[0].chebi_id",
        "value": "butyric acid",
        "tag": "needs_review",
        "resolved_id": null,
        "candidates": [{"chebi_id": "CHEBI:30772", "name": "butyric acid", "stars": 3}],
        "note": "One high-confidence candidate found; requires human confirmation"
      }
    ]
  }
}
```

- `status: clean` — all nulls are confirmed_null
- `status: filled` — at least one null was resolved to an ID
- `status: needs_review` — at least one `needs_review` finding present

**When a field is tagged `filled`:** update the corresponding field in the staging object (not just the `null_review` annotation) so the staging file reflects the resolved ID.

**When a field is tagged `needs_review`:** leave the field null in the staging object; the candidate(s) appear in `null_review.findings` for the human reviewer.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only assign IDs confirmed by the data source. Never guess. |
| Null on uncertainty | If confidence is below the threshold for auto-fill, use `needs_review` — not `confirmed_null`. |
| Sentinel pass-through | `none documented` and `unknown` are confirmed_null without re-attempt. |
| KEGG ID requires label | Whenever a `kegg_disease_id` is resolved (whether by this agent or flagged as filled), `ref_label` must be populated with the canonical disease name from the flat file in the same operation. Never write a KEGG Disease ID without its label. |
| Non-blocking | All lookup failures go to `null_review`; do not halt. |
| Rate limiting | NLM API: max 3 requests/second. ChEBI: pause 500ms between requests. |
| Scope | Does not modify text values, evidence grades, or clinical fields — ext_ids, `ref_label`, and `ncbi_taxid` only. |
| Mirror consistency | When a Phase 2 agent's matching rules change, the corresponding re-attempt section in this file must be updated in parallel. |
