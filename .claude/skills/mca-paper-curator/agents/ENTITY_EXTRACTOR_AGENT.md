---
name: entity_extractor_agent
description: "Phase 1 agent for the MCA Paper Curator skill. Extracts clinical profile, metabolites, and clinical associations from the paper for each taxon. Biology and ecology fields are populated by db_fetch_agent from NCBI Taxonomy and BacDive — do not extract those from the PDF. Runs in parallel with routing_agent and db_fetch_agent."
---

# ENTITY_EXTRACTOR_AGENT.md — MCA Entity Extractor Agent

Extracts the **clinical layer** of the MCA entity model from the research paper for each taxon confirmed in Phase 0. Biology and ecology fields are handled by `db_fetch_agent` (NCBI Taxonomy + BacDive) — this agent does not touch those fields. Produces a structured extraction per taxon that feeds into the staging file. Runs in parallel with `routing_agent` and `db_fetch_agent`.

---

## Inputs

| Input | Description |
|-------|-------------|
| Phase 0 output | Full paper metadata and confirmed taxa list from `paper_analyst_agent` |
| PDF | The original paper (for re-reading specific sections as needed) |
| `templates/TAXON_PASSPORT.md` | Field template to fill in |
| `references/CONTROLLED_VOCABULARY.md` | Allowed values for all controlled fields |

---

## Task

For each taxon in the confirmed taxa list:
1. Extract all MCA entity fields that the paper explicitly reports
2. Map extracted values to controlled vocabulary terms
3. Identify clinical associations (claim + PMID)
4. Leave fields as `null` if not reported — do not infer or fabricate
5. Note any unmapped terms or ambiguities in `extraction_notes`

---

## Extraction Scope per Taxon

### Identity
- `preferred_name` only: use the value resolved in Phase 0 by `paper_analyst_agent` — do not re-resolve. All other identity fields (lineage, rank, domain, TaxID, synonyms) are populated by `db_fetch_agent`.

### Biology
**Do not extract from the paper.** Biology fields (`gram_status`, `oxygen_tolerance`, `morphology`, `key_traits`) are populated by `db_fetch_agent` from BacDive. Leave the entire `biology` block absent from your output — it will be merged in from `db_fetch_agent`.

### Ecology
**Do not extract primary niches or reservoirs from the paper.** Those fields are populated by `db_fetch_agent` from BacDive.

**Exception — transmission routes:** If the paper explicitly reports a transmission route for this taxon in its own Results or Discussion, extract it. Background statements from Introduction do not qualify.

### Clinical Profile
- Pathobiont status, clinical roles, typical specimens, bloom triggers, risk contexts, AMR highlights
- Source: paper text — only extract what is directly stated or clearly implied by the study's own data or conclusions
- `bloom_triggers`: extract only triggers this paper's own data or primary conclusions associate with the taxon's overgrowth or expansion. Do not extract triggers mentioned in Introduction or Discussion as prior knowledge from other studies.

### Clinical Associations
- Each distinct clinical claim linking the taxon to a condition or outcome
- Must include: association text, PMID (the source paper's PMID at minimum)
- One association block per distinct claim

---

## Extraction Rules

| Rule | Detail |
|------|--------|
| Fidelity | Only extract what the paper explicitly states. Do not infer beyond reported findings. |
| No conflict notes | Do not add extraction_notes about findings appearing to contradict existing passport data or other studies. MCA collects every finding as reported — apparent contradictions across studies are expected and intentional. Interpretation is the user's job. |
| Controlled vocabulary | All values must match `references/CONTROLLED_VOCABULARY.md`. Map non-standard terms; note the original in parentheses. |
| Null vs unknown | Use `null` when the paper does not report a field. Use `"unknown"` only when it is a valid controlled vocabulary value for that field. |
| Synonyms | Populate `synonyms` from NCBI Taxonomy "Common names" only. Do not derive synonyms from the paper text, other databases, or background knowledge. If NCBI has no common names for this taxon, use `[]`. |
| Clinical associations | Each association must be a discrete, citable claim. Do not merge multiple claims into one block. |
| PMIDs | Use the source paper's PMID for all associations extracted from it. If the paper cites additional PMIDs for a specific claim, include those too. |
| Primary focus taxa | Extract all applicable fields. |
| Incidental taxa | Extract only what the paper explicitly states; do not supplement from background knowledge. |

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "passport_id": null,
  "proposed_changes": {
    "identity": {
      "preferred_name": "",
      "taxon_rank": "",
      "domain": "",
      "lineage": "",
      "ncbi_taxid": null,
      "synonyms": []
    },
    "biology": {
      "gram_status": null,
      "oxygen_tolerance": null,
      "morphology": null,
      "key_traits": []
    },
    "ecology": {
      "primary_niches": [
        {"value": "", "mesh_anatomy_id": null}
      ],
      "reservoirs": [],
      "transmission_routes": []
    },
    "clinical_profile": {
      "is_pathobiont": null,
      "clinical_roles": [],
      "typical_specimens": [
        {"value": "", "mesh_anatomy_id": null}
      ],
      "bloom_triggers": [
        {"value": "", "kegg_drug_id": null}
      ],
      "risk_contexts": [],
      "amr_highlights": [
        {"value": "", "aro_id": null}
      ]
    },
    "metabolites": [
      {
        "metabolite_name": "",
        "relationship": "produces | consumes | modifies",
        "kegg_compound_id": null,
        "chebi_id": null
      }
    ],
    "clinical_associations": [
      {
        "association_text": "",
        "evidence_type": "",
        "assoc_refs": [],
        "pmids": []
      }
    ],
    "taxon_level_pmids": []
  },
  "extraction_notes": []
}
```

`passport_id` is populated by `routing_agent` — leave as `null` here.

`ncbi_taxid` and all `pmids` are integers, not strings. Use `null` (not `""`) when not determinable.

For `primary_niches`, `typical_specimens`, `bloom_triggers`, `amr_highlights`: use `[]` when empty. When values are present, use object form — set `mesh_anatomy_id`, `kegg_drug_id`, or `aro_id` to `null` if the ID is not known; the entity extractor does not need to resolve external IDs.

For `metabolites`: use `[]` when the paper reports no metabolite data for this taxon.

---

## Extraction Notes

Populate `extraction_notes` when:
- A term could not be mapped to controlled vocabulary
- A field value is ambiguous or contradicted within the paper
- A clinical association is uncertain or only incidentally mentioned
- The paper uses an outdated taxon name that was resolved to a current name
