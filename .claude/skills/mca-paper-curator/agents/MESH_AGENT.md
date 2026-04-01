---
name: mesh_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Enriches entity_extractor output with MeSH identifiers: fetches the paper's MeSH annotations from the NLM E-utilities API, filters and assigns relevant terms per clinical association, and resolves MeSH anatomy IDs for extracted body sites and typical specimens. Runs in parallel with kegg_agent and aro_agent."
---

# MESH_AGENT.md — MCA MeSH Enrichment Agent

Enriches entity extractor output with Medical Subject Headings (MeSH) identifiers. Receives the source PMID and entity extractor output. Performs two tasks: (1) fetches the paper's MeSH annotations from NLM and maps them to individual clinical associations; (2) resolves MeSH anatomy IDs for extracted body site and specimen terms. Returns enriched data for staging file assembly.

---

## Inputs

| Input | Description |
|-------|-------------|
| `pmid` | PubMed ID of the source paper (integer, from `source_paper.pmid`) |
| `entity_extractor output` | Full output from `entity_extractor_agent` — specifically `clinical_associations[]`, `ecology.primary_niches[]`, `clinical_profile.typical_specimens[]` |
| `references/CONTROLLED_VOCABULARY.md` | Controlled vocabulary for body site and specimen terms — use the canonical CV term as the lookup query for anatomy ID resolution in Task 2 |

---

## Task

### Task 1 — Fetch paper MeSH annotations and map to associations

1. Fetch the paper's full MeSH annotation list from NLM E-utilities:
   ```
   GET https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi
       ?db=pubmed&id={pmid}&retmode=xml
   ```
2. Parse the `<MeshHeadingList>` block from the response. Extract all `<DescriptorName>` elements with their `UI` attribute (the MeSH ID, e.g., `D003141`).
3. For each clinical association in the entity extractor output:
   - Read the `association_text`
   - Identify which fetched MeSH terms describe the disease, condition, or outcome referenced in that association (semantic match — a term is relevant if it describes the primary clinical condition or outcome in the claim)
   - Include all relevant terms; skip a term if it describes only the study methodology or the taxon itself rather than the condition
4. If no relevant MeSH terms can be identified for an association, return `assoc_refs: []` for that association — do not force a match.
5. If `pmid` is null, skip Task 1 entirely and return empty `assoc_refs` for all associations.

### Task 2 — Resolve MeSH anatomy IDs for body sites and specimens

1. For each item in `primary_niches[]` and `typical_specimens[]`:
   - If `mesh_anatomy_id` is already populated (non-null), skip.
   - Otherwise, resolve the MeSH anatomy ID using the NLM MeSH Lookup API:
     ```
     GET https://id.nlm.nih.gov/mesh/lookup/descriptor
         ?label={term}&match=contains&limit=5
     ```
   - From the response, select the best match from the anatomy/body part subtree. Prefer exact matches over partial.
   - If the lookup returns no useful anatomy match, leave `mesh_anatomy_id` as `null`.
2. Use the MCA controlled vocabulary canonical term (from `references/CONTROLLED_VOCABULARY.md`) as the lookup query — not raw text from the paper.

---

## NLM API Notes

- **efetch endpoint:** `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id={pmid}&retmode=xml`
- **MeSH lookup endpoint:** `https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5`
- No API key required for low-volume use. Add `&tool=MCA&email=` parameters if rate limiting is encountered.
- Rate limit: maximum 3 requests/second to NCBI APIs. Add a short delay between requests if fetching anatomy IDs for many terms.
- If the NLM API returns an error or times out: log in `extraction_notes`, set affected fields to `null`, continue.

---

## Filtering Rules for Association MeSH Matching

| Include | Exclude |
|---------|---------|
| MeSH terms describing the disease, syndrome, or clinical outcome in the association_text | Terms describing the taxon itself (e.g., organism name) |
| Terms describing a population or risk factor directly named in the association | Study design terms (e.g., "Cohort Studies", "Clinical Trials") |
| Terms describing a treatment outcome if the association discusses treatment response | General methodology terms |

When uncertain whether a MeSH term is relevant to a specific association: include it and note in `extraction_notes`.

---

## Output Format

One object per taxon, providing enriched versions of the relevant fields:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "clinical_associations": [
      {
        "association_text": "",
        "assoc_refs": [
          {"ref_type": "mesh", "ref_id": "D003141", "ref_label": "Clostridioides difficile Infections"},
          {"ref_type": "mesh", "ref_id": "D012008", "ref_label": "Recurrence"}
        ]
      }
    ],
    "primary_niches": [
      {"value": "gut", "mesh_anatomy_id": "D007422"}
    ],
    "typical_specimens": [
      {"value": "stool", "mesh_anatomy_id": "D005243"}
    ]
  },
  "mesh_notes": []
}
```

- `clinical_associations` list order must match the order returned by `entity_extractor_agent`.
- `assoc_refs` contains only `ref_type: "mesh"` entries — KEGG Disease IDs are added by `kegg_agent`.
- Omit `primary_niches` or `typical_specimens` from output if no IDs were resolved for them.
- Populate `mesh_notes` when: term not found, ambiguous match chosen, NLM API error encountered.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return MeSH IDs confirmed by the NLM API response. Never guess or invent IDs. |
| Null on miss | If no anatomy match is found for a body site, return `null` — not an approximate match. |
| Empty on no PMID | If `source_paper.pmid` is null, return empty `assoc_refs` for all associations without error. |
| Length preservation | Return exactly as many association objects as the entity extractor output — one per association, in the same order. Never skip an association that has no MeSH match; return it with `assoc_refs: []`. |
| Order preservation | Return association objects in the same order as the entity extractor output. |
| Non-blocking | Errors from the NLM API do not halt the skill — log in `mesh_notes` and continue. |
