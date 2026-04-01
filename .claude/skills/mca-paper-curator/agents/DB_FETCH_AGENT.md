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

**Use API v2.** The old v1 endpoints (`/taxon/{id}/`) are frozen at the April 2025 data state and kept only for backward compatibility — do not use them.

**Base URL:** `https://api.bacdive.dsmz.de`

**Endpoints:**

| Use case | Endpoint |
|----------|----------|
| Fetch full strain record by BacDive ID | `GET /v2/fetch/{bacdive_id}` |
| Search by taxon (species) | `GET /v2/taxon/{genus}/{species_epithet}` |
| Search by taxon (genus only) | `GET /v2/taxon/{genus}` |
| Search by 16S accession | `GET /v2/sequence_16s/{seq_acc_num}` |
| Search by genome accession | `GET /v2/sequence_genome/{seq_acc_num}` |

**Taxon name parsing for query construction:**

| Taxon rank | Query strategy |
|------------|---------------|
| species | `GET /v2/taxon/{genus}/{species_epithet}` |
| genus | `GET /v2/taxon/{genus}` |
| family or above | No direct family-level endpoint. Query by the **type genus** of the family if known; otherwise skip BacDive and log `"BacDive v2 has no family-level endpoint; BacDive fetch skipped"` in `db_fetch_notes`. Biology/ecology fields remain `null`. |

BacDive returns JSON. Each response contains an array of strain records. When multiple records are returned, aggregate as follows:
- **Scalar fields** (`gram_status`, `oxygen_tolerance`, `morphology`): use the majority value across records. If records are heterogeneous (>20% minority), set to `null` and log in `db_fetch_notes`.
- **List fields** (`primary_niches`, `reservoirs`): union of all unique controlled-vocabulary values across records.

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
| species / genus | Extract the BacDive internal strain ID from the API response (top-level `id` field on each strain record). Use the first record's ID. Construct: `https://bacdive.dsmz.de/strain/{bacdive_id}` — e.g., `https://bacdive.dsmz.de/strain/14487` for *Staphylococcus aureus*. |
| family or above | No strain records are fetched (no family-level endpoint). Construct an advsearch URL using the family name: `https://bacdive.dsmz.de/advsearch?fg[0][gc]=OR&fg[0][fl][1][fd]=Family&fg[0][fl][1][fo]=contains&fg[0][fl][1][fv]={FamilyName}&fg[0][fl][1][fvd]=strains-family-1` — e.g., `https://bacdive.dsmz.de/advsearch?fg[0][gc]=OR&fg[0][fl][1][fd]=Family&fg[0][fl][1][fo]=contains&fg[0][fl][1][fv]=Enterobacteriaceae&fg[0][fl][1][fvd]=strains-family-1` |

**`bacdive_url` for family-rank taxa:**
BacDive v2 has no family-level endpoint, so no strain records are fetched. However, always populate `bacdive_url` with the advsearch URL using the family name. This is the only field written to `biology` for family-rank taxa — gram_status, oxygen_tolerance, morphology, and key_traits remain null.

**`biology` block rule:** Always write a `biology` block in the staging file when a `bacdive_url` can be constructed (i.e., whenever `preferred_name` is known). Never omit the block solely because biology fields are null.

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
| `rod` / `bacillus` | `rod` |
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
