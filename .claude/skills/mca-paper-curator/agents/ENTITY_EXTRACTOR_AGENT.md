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
- Preferred name, taxon rank, domain, lineage, NCBI TaxID (integer), synonyms
- Source: paper text + NCBI Taxonomy (for lineage and synonym resolution)
- `preferred_name`: use the value resolved in Phase 0 by `paper_analyst_agent` — do not re-resolve or independently standardise. `paper_analyst_agent` is the authoritative source for this field.
- `domain` is derived from the first element of lineage (e.g., `Bacteria`)
- `synonyms`: populate from the **"Common names"** field in the NCBI Taxonomy record for this taxon (look up by TaxID or preferred name). NCBI is the authoritative source — do not add names from the paper, other databases, or background knowledge. If NCBI lists no common names, set `synonyms: []`.

### Biology
- Gram status, oxygen tolerance, morphology, key traits
- Source: paper text — only extract what the paper explicitly states for this taxon. Do not add from background knowledge.
- For taxa at **family rank or above**: only populate `gram_status`, `oxygen_tolerance`, and `morphology` if the paper explicitly characterises the majority of the family with a shared trait (e.g., *"Lachnospiraceae are obligate anaerobes"*). If members are heterogeneous or the paper does not characterise biology at the family level, set to `null`.

### Ecology
- Primary niches, reservoirs, transmission routes
- Source: **Results and Discussion only**. Do not extract from Introduction or Methods background text. A niche or reservoir qualifies only if the paper's own data or primary conclusions place the taxon there. Background statements about well-known ecological context do not qualify.

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
