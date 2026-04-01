---
name: entity_extractor_agent
description: "Phase 1 agent for the MCA Paper Curator skill. Maps paper findings to the MCA entity model per taxon — biology, ecology, clinical profile, and clinical associations. Runs in parallel with routing_agent. Only extracts what the paper explicitly reports."
---

# ENTITY_EXTRACTOR_AGENT.md — MCA Entity Extractor Agent

Maps findings from the research paper to the MCA entity model for each taxon confirmed in Phase 0. Produces a structured extraction per taxon that feeds into the staging file. Runs in parallel with `routing_agent`.

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
- Preferred name, taxon rank, lineage, NCBI TaxID, synonyms
- Source: paper text + NCBI Taxonomy (for lineage resolution)

### Biology
- Gram status, oxygen tolerance, morphology, key traits
- Source: paper Methods/Introduction or established microbiology (only if the paper references it explicitly)

### Ecology
- Primary niches, reservoirs, transmission routes
- Source: paper text — only report niches/reservoirs the paper explicitly describes for this taxon

### Clinical Profile
- Pathobiont status, clinical roles, typical specimens, bloom triggers, risk contexts, AMR highlights
- Source: paper text — only extract what is directly stated or clearly implied by the study design

### Clinical Associations
- Each distinct clinical claim linking the taxon to a condition or outcome
- Must include: association text, PMID (the source paper's PMID at minimum)
- One association block per distinct claim

---

## Extraction Rules

| Rule | Detail |
|------|--------|
| Fidelity | Only extract what the paper explicitly states. Do not infer beyond reported findings. |
| Controlled vocabulary | All values must match `references/CONTROLLED_VOCABULARY.md`. Map non-standard terms; note the original in parentheses. |
| Null vs unknown | Use `null` when the paper does not report a field. Use `"unknown"` only when it is a valid controlled vocabulary value for that field. |
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
      "lineage": "",
      "ncbi_taxid": "",
      "synonyms": []
    },
    "biology": {
      "gram_status": null,
      "oxygen_tolerance": null,
      "morphology": null,
      "key_traits": []
    },
    "ecology": {
      "primary_niches": [],
      "reservoirs": [],
      "transmission_routes": []
    },
    "clinical_profile": {
      "is_pathobiont": null,
      "clinical_roles": [],
      "typical_specimens": [],
      "bloom_triggers": [],
      "risk_contexts": [],
      "amr_highlights": []
    },
    "clinical_associations": [
      {
        "association_text": "",
        "pmids": []
      }
    ],
    "taxon_level_pmids": []
  },
  "extraction_notes": []
}
```

`passport_id` is populated by `routing_agent` — leave as `null` here.

---

## Extraction Notes

Populate `extraction_notes` when:
- A term could not be mapped to controlled vocabulary
- A field value is ambiguous or contradicted within the paper
- A clinical association is uncertain or only incidentally mentioned
- The paper uses an outdated taxon name that was resolved to a current name
