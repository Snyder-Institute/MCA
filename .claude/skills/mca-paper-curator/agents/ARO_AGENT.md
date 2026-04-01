---
name: aro_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Maps extracted AMR phenotype names (ESBL, CRE, MRSA, VRE, etc.) to CARD Antibiotic Resistance Ontology (ARO) identifiers using the CARD database. Runs in parallel with mesh_agent and kegg_agent."
---

# ARO_AGENT.md — MCA CARD/ARO Enrichment Agent

Maps Antimicrobial Resistance (AMR) phenotype names extracted by `entity_extractor_agent` to stable ARO identifiers from the Comprehensive Antibiotic Resistance Database (CARD). Returns enriched AMR highlight objects with `aro_id` populated where a confident match is found.

**CARD database:** [card.mcmaster.ca](https://card.mcmaster.ca) — maintained by McMaster University.  
**ARO format:** `ARO:NNNNNNN` (e.g., `ARO:3000026`)

---

## Background

CARD's Antibiotic Resistance Ontology (ARO) is the standard controlled vocabulary for AMR mechanisms, genes, and phenotypes. Each ARO term has:
- A stable identifier: `ARO:NNNNNNN`
- A preferred name (e.g., `extended-spectrum beta-lactamase (ESBL)`)
- Synonyms and related terms
- Links to resistance mechanisms, affected drug classes, and organism associations

MCA uses ARO IDs on `amr_highlights` to make resistance phenotypes machine-readable and cross-database queryable.

---

## Inputs

| Input | Description |
|-------|-------------|
| `entity_extractor output` | `clinical_profile.amr_highlights[]` — list of `{value, aro_id: null}` objects |

---

## Data Source

CARD provides a downloadable ontology file:

**Download URL:** `https://card.mcmaster.ca/latest/data` (compressed archive; contains `aro.obo` and `card.json`)

**Preferred approach — local CARD ontology file:**
If `card.json` or `aro.obo` is available locally (e.g., previously downloaded), read from disk and build an in-memory name → ARO ID index. This avoids repeated downloads.

**Fallback — CARD REST API / web lookup:**
If no local file is available, use the CARD ontology browser to look up individual terms:
```
GET https://card.mcmaster.ca/ontology/{aro_accession}
```
Or use WebSearch to query CARD for each phenotype name.

---

## Task

### Task 1 — Build ARO lookup index (if local file available)

1. Check for a local `card.json` or `aro.obo` file. No local CARD path is configured in project memory — if a local file is not present in the working directory or a standard location, proceed directly to the per-term web lookup fallback (Task 2 fallback path). Do not halt.
2. If `card.json` is available: parse the JSON and build:
   ```
   aro_index: {lowercase_name → ARO_id, ...}
   ```
   Index all preferred names and synonyms.
3. If `aro.obo` is available: parse OBO format (`[Term]` blocks with `id:`, `name:`, `synonym:` fields) and build the same index.
4. If neither is available: fall through to per-term web lookup (Task 2 fallback path).

### Task 2 — Map AMR phenotype names to ARO IDs

For each AMR highlight in `amr_highlights[]`:
1. Take the `value` field (e.g., `"ESBL-producing"`, `"CRE"`, `"fluoroquinolone-resistant strains documented"`)
2. Normalise: strip qualifier words (`-producing`, `-resistant`, `documented`, `strains`, etc.) to extract the core phenotype term (e.g., `"ESBL"`, `"CRE"`, `"fluoroquinolone resistance"`)
3. Apply common abbreviation expansions before lookup:

| Abbreviation | Expanded term |
|---|---|
| `ESBL` | extended-spectrum beta-lactamase |
| `CRE` | carbapenem-resistant Enterobacterales |
| `MRSA` | methicillin-resistant Staphylococcus aureus |
| `VRE` | vancomycin-resistant Enterococcus |
| `CRKP` | carbapenem-resistant Klebsiella pneumoniae |
| `MDR` | multidrug resistance |
| `PDR` | pan-drug resistance |
| `ESBL-producing` | extended-spectrum beta-lactamase |
| `CRE` | carbapenem resistance |

4. Attempt lookup against `aro_index` (exact → alias → substring).
5. If using web fallback: use WebSearch or WebFetch against CARD to find the ARO ID for the phenotype.
6. Return the ARO ID in format `ARO:NNNNNNN`. If no confident match: return `null`.

---

## Matching Strategy

| Step | Type | Rule |
|------|------|------|
| 1 | Exact | Normalised phenotype name matches ARO preferred name (case-insensitive) |
| 2 | Abbreviation | Apply abbreviation expansion table above before matching |
| 3 | Alias | Normalised name matches any ARO synonym |
| 4 | Substring | ARO name contains the phenotype term |
| — | No match | Return `null`; do not fabricate IDs |

**Confidence threshold:** Only assign an ARO ID when confident the match describes the same resistance concept. A partial match to a tangentially related term is worse than `null`.

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "amr_highlights": [
      {"value": "ESBL-producing", "aro_id": "ARO:3000026"},
      {"value": "multidrug-resistant (MDR)", "aro_id": "ARO:3000707"},
      {"value": "fluoroquinolone-resistant strains documented", "aro_id": "ARO:3000150"},
      {"value": "none documented", "aro_id": null}
    ]
  },
  "aro_notes": []
}
```

- Return the full `amr_highlights` list in original order, with `aro_id` populated where matched and `null` where not.
- Populate `aro_notes` when: no match found, abbreviation expansion used (note the expansion), web lookup used, CARD data source unavailable.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return ARO IDs confirmed from CARD data. Never guess or invent IDs. |
| Null on miss | If no confident match is found, return `null` — not the nearest approximate. |
| `none documented` | Always returns `aro_id: null` — it is a sentinel value, not a phenotype. |
| `unknown` | Always returns `aro_id: null`. |
| Non-blocking | Failure to retrieve CARD data does not halt the skill. Log in `aro_notes` and return all `aro_id: null`. |
| Data currency | CARD is actively maintained. If the local file is older than 6 months, note in `aro_notes` that a refresh may be warranted. |
