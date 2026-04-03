---
name: db_fetch_agent
description: "Phase 1 agent for the MCA Paper Curator skill. Given a TaxID, queries NCBI Taxonomy and BacDive to populate identity (lineage, synonyms) and biology/ecology fields. Runs in parallel with entity_extractor_agent. Best-effort — failures are logged, not blocking."
---

# DB_FETCH_AGENT.md — MCA Database Fetch Agent

Populates identity, biology, and ecology fields by querying external structured databases using the NCBI TaxID resolved in Phase 0. Replaces PDF reading for all fields that are available in NCBI Taxonomy or BacDive. Runs in parallel with `entity_extractor_agent` in Phase 1.

---

## Inputs

| Input | Description |
|-------|-------------|
| `ncbi_taxid` | Integer TaxID from Phase 0 `paper_analyst_agent` output |
| `preferred_name` | Taxon name from Phase 0, used as fallback if TaxID is null |
| `references/CONTROLLED_VOCABULARY.md` | Required for mapping fetched values to controlled terms |

---

## Data Sources

### 1. NCBI Taxonomy (E-utilities)

**Endpoint:**
```
GET https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi
    ?db=taxonomy&id={taxid}&rettype=xml&retmode=xml
```

Fallback (name search when TaxID is null):
1. **Local index first** — load `ncbi_names_index.json` (path from project memory `reference_ncbi_path.md`, passed by orchestrator): `{scientific_name → taxid}`. Look up `preferred_name` directly.
2. **API fallback** — if not found in local index:
```
GET https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi
    ?db=taxonomy&term={preferred_name}[Scientific Name]&retmode=json
```
Then fetch the top hit TaxID.

**Fields used:**

| NCBI field | MCA field |
|------------|-----------|
| `ScientificName` | Confirms `preferred_name` |
| `Lineage` | `identity.lineage` (semicolon-separated) |
| `Rank` | `identity.taxon_rank` |
| `OtherNames/CommonName` | `identity.synonyms` |
| `TaxId` | `identity.ncbi_taxid` |

**Synonym rule:** Populate `identity.synonyms` from `OtherNames/CommonName` entries only. Do not add names from BacDive, the paper, or background knowledge. If NCBI has no `CommonName` entries, set `synonyms: []`.

---

### 2. BacDive (DSMZ REST API v2)

**Authentication:** None required. As of February 2026 the BacDive API is freely accessible with no sign-up and no account.

**Base URL:** `https://api.bacdive.dsmz.de` — no `/v2/` path prefix despite being API v2.

**Local cache first (preferred):** Before making any live BacDive API call, check the local cache at the path stored in project memory `reference_bacdive_path.md` (keyed by `ncbi_taxid`). If the taxon is present in the cache and has `strains` entries, use those records directly — skip all API calls. Only fall back to live API if the taxon is absent from the cache or the cache is unavailable.

**Endpoints (live API fallback):**

| Use case | Endpoint |
|----------|----------|
| Search by NCBI TaxID | `GET /search?s[ncbi_tax_id]={taxid}` |
| Fetch full strain record by BacDive ID | `GET /fetch/{bacdive_id}` |
| Search by taxon (species) | `GET /taxon/{genus}/{species_epithet}` |
| Search by taxon (genus only) | `GET /taxon/{genus}` |
| Search by 16S accession | `GET /sequence_16s/{seq_acc_num}` |
| Search by genome accession | `GET /sequence_genome/{seq_acc_num}` |

**Query strategy (3-pass — stop at first hit):**

| Pass | Query | Notes |
|------|-------|-------|
| 1 | `GET /search?s[ncbi_tax_id]={ncbi_taxid}` | Unambiguous; immune to name changes and synonyms. Always try first. |
| 2 | `GET /taxon/{genus}/{species_epithet}` or `GET /taxon/{genus}` | Parsed from `preferred_name` (split on whitespace; take first two tokens). |
| 3 | Same name-based query for each synonym in turn | Use synonyms from the MCA XML `<Synonyms>` block; stop at first hit. |

Log which pass produced the hit in `db_fetch_notes` (e.g., `"BacDive matched via synonym 'Clostridium difficile'"`). If all three passes return zero results, log `"no_bacdive_match"` and leave biology/ecology fields null.

**Family-rank taxa:** No BacDive endpoint exists for family-level lookup. Skip all three passes. Log `"family_rank_skipped"`. Only `bacdive_url` (advsearch) is written.

BacDive returns JSON. Each response contains an array of strain records. The cache sorts type strains first (`is_type_strain: true`). When aggregating:
- **Scalar fields** (`gram_status`, `oxygen_tolerance`, `morphology`): if any type strain records are present, use majority vote across type strains only. If no type strains are present, use majority vote across all fetched records. Heterogeneity threshold: if the minority fraction exceeds 20% of the records used for voting, set to `null` and log (e.g., `"gram_status heterogeneous across type strains — set to null"`).
- **List fields** (`primary_niches`, `reservoirs`): union of all unique controlled-vocabulary values across all fetched records (type strains + others).

**Field mapping:**

| BacDive v2 JSON field | MCA field | Notes |
|-----------------------|-----------|-------|
| `morphology_physiology.gram_stain` | `biology.gram_status` | Map to CV |
| `morphology_physiology.oxygen_tolerance` | `biology.oxygen_tolerance` | Map to CV |
| `morphology_physiology.cell_morphology` | `biology.morphology` | Map to CV |
| `morphology_physiology.observation` | `biology.key_traits` | Filter to CV terms only |
| `isolation_sources_and_natural_habitats.isolation_source` | `ecology.primary_niches` | Map to CV |
| `isolation_sources_and_natural_habitats.natural_habitat` | `ecology.reservoirs` | Map to CV |
| `isolation_sources_and_natural_habitats.host_organism` | `ecology.reservoirs` | Add "human" / "animal" / "environment" per CV |
| _(constructed)_ | `biology.bacdive_url` | See below |

**`bacdive_url` construction:**

| Taxon rank | URL strategy |
|------------|-------------|
| species / subspecies | Select the best-matching strain record and construct `https://bacdive.dsmz.de/strain/{bacdive_id}`. See **Strain selection rules** below. |
| genus | BacDive is strain-level — there is no single representative strain for a genus. Do **not** write a `bacdive_url` for genus-rank passports. Leave `bacdive_url` null and log `"genus_rank_no_url"`. |
| family or above | Leave `bacdive_url` null and log `"family_rank_no_url"`. BacDive is available at species level and below only. |

**Strain selection rules (for species / subspecies `bacdive_url`):**

Select a strain record using this priority order — stop at the first match:

1. **TaxID match + type strain**: record whose NCBI TaxID list includes the passport's `ncbi_taxid` AND `is_type_strain: true`
2. **TaxID match, not type strain**: record whose NCBI TaxID list includes the passport's `ncbi_taxid` (use the first such record)
3. **No TaxID match**: if no record lists the passport's `ncbi_taxid`, log `"bacdive_taxid_mismatch: no record matches ncbi_taxid={taxid}"` and set `bacdive_url: null` — **do not link to a non-matching record**

When multiple records match at the same priority level, prefer type strains; among type strains, prefer the record whose organism name most closely matches `preferred_name` (exact match > genus match).

**Subspecies passports:** if the passport `taxon_rank` is `species` but BacDive only returns subspecies records, prefer the record whose organism name matches `preferred_name` most exactly (e.g., for *Lacticaseibacillus paracasei* prefer a record named exactly *L. paracasei* subsp. *paracasei*, not *L. paracasei* subsp. *tolerans*). Log the selected subspecies name in `db_fetch_notes`.

**`biology` block rule:** Always write a `biology` block in the staging file even when all biology fields are null. Never omit the block solely because biology fields are null.

**Transmission routes:** BacDive does not provide transmission route data. Leave `ecology.transmission_routes: []` — this field remains for `entity_extractor_agent` to populate from the paper if reported.

---

## Controlled Vocabulary Mapping

All fetched values **must** be mapped to `references/CONTROLLED_VOCABULARY.md` before writing to the output. Common mappings:

| BacDive value | MCA controlled term |
|---------------|---------------------|
| `Gram-positive` | `gram-positive` |
| `Gram-negative` | `gram-negative` |
| `variable` | `gram-variable` |
| `aerobic` | `aerobe` |
| `anaerobic` | `obligate anaerobe` |
| `facultatively anaerobic` | `facultative anaerobe` |
| `microaerophilic` | `microaerophile` |
| `rod` / `bacillus` | `bacillus (rod)` |
| `coccus` / `sphere` | `coccus` |
| `gastrointestinal tract` | `gut` |
| `feces` / `stool` | `gut` |
| `blood` | `blood` |
| `human` | `human` |
| `soil` | `environment` |

If a fetched value cannot be mapped to a controlled term, omit it and log in `db_fetch_notes`.

---

## Family-rank and Above

BacDive records are strain-level. For taxa at family rank or above, BacDive will return records from many diverse strains. Apply the aggregation rules above strictly:
- If members of a family are biologically heterogeneous (common at family level), scalar biology fields will typically resolve to `null` — this is correct and expected.
- Log `"BacDive returned N heterogeneous records; scalar biology fields set to null"` in `db_fetch_notes`.
- List fields (niches, reservoirs) may still yield usable aggregated values if members share a predominant habitat.

---

## Failure Handling

All failures are best-effort — they log to `db_fetch_notes` and do not block staging file output.

| Failure | Behaviour |
|---------|-----------|
| `ncbi_taxid` is null | Try name search; if still no TaxID, set all identity fields to null and log |
| NCBI API unavailable | Set lineage and synonyms to null; log |
| BacDive API unavailable | Set all biology/ecology fields to null; log |
| BacDive returns no records for this taxon | Set all biology/ecology fields to null; log |
| Taxon is at family rank or above | Skip BacDive (no family-level endpoint); log; fields remain null |
| Value not mappable to controlled vocab | Omit value; log original term in `db_fetch_notes` |

---

## Output Format

```json
{
  "preferred_name": "",
  "ncbi_taxid": null,
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
    "primary_niches": [],
    "reservoirs": [],
    "transmission_routes": []
  },
  "db_fetch_notes": []
}
```

`db_fetch_notes` are folded into `extraction_notes[]` of the staging file during the Phase 1→2 merge.

---

## What This Agent Does NOT Provide

| Field | Correct source |
|-------|---------------|
| `clinical_profile.*` | `entity_extractor_agent` (paper) |
| `metabolites` | `entity_extractor_agent` (paper) |
| `clinical_associations` | `entity_extractor_agent` (paper) |
| `ecology.transmission_routes` | `entity_extractor_agent` (paper) if reported |
| `is_pathobiont` | `entity_extractor_agent` (paper) |
| Ontology IDs (MeSH, KEGG, ARO) | Phase 2 agents |
