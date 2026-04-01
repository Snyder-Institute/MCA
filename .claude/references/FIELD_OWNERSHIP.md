# FIELD_OWNERSHIP.md — MCA Database Field Ownership Reference

Every field in the MCA v1.0 schema mapped to the agent responsible for populating it,
the strategy used, and the authoritative source of information.

**Skills involved:**
- `mca-paper-curator` (phases 0–3): paper_analyst_agent, db_fetch_agent,
  entity_extractor_agent, routing_agent, grading_agent, mesh_agent, kegg_agent, aro_agent
- `mca-xml-update`: xml_writer_agent, orchestrator

---

## Table: `meta`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `key_name` | `xml2sql.py` | Hardcoded keys written at SQL generation time | XML `<Meta>` block |
| `key_value` | `xml2sql.py` | Read from `<version>` element of XML `<Meta>` block | XML file itself |

---

## Table: `passport`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `id` | `xml_writer_agent` | Sequential surrogate integer, incremented per passport written in a session | Assigned at write time — not in staging file |
| `passport_id` | `mca-xml-update` orchestrator | Find highest existing `NNNNNN` for the domain prefix in the XML; increment by 1; zero-pad to 6 digits | Derived from current XML state before write |
| `preferred_name` | `paper_analyst_agent` (Phase 0) | Resolve taxon name from paper to current valid nomenclature; confirm against NCBI Taxonomy; this agent is the authoritative source — no other agent re-resolves it | Paper text + NCBI Taxonomy name lookup |
| `taxon_rank` | `paper_analyst_agent` (Phase 0) | Infer rank from paper usage; confirm against NCBI Taxonomy record | Paper text + NCBI Taxonomy |
| `domain` | `db_fetch_agent` | Derived from first element of lineage returned by NCBI Taxonomy `efetch` | NCBI Taxonomy |
| `lineage` | `db_fetch_agent` | `GET https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id={taxid}&rettype=xml` → `<Lineage>` element; semicolon-separated | NCBI Taxonomy E-utilities |
| `ncbi_taxid` | `paper_analyst_agent` (Phase 0) | Extracted from paper if stated; otherwise NCBI name search: `GET .../esearch.fcgi?db=taxonomy&term={name}[Scientific Name]` → top hit TaxID | Paper text, then NCBI Taxonomy E-utilities |
| `is_pathobiont` | `entity_extractor_agent` | Read paper for explicit pathobiont characterisation; map to controlled vocabulary (`yes` / `no` / `context dependent` / `unknown`); default `unknown` if not stated | Paper text (all sections) |
| `last_reviewed` | `mca-xml-update` orchestrator | Set to the `last_reviewed` date from the staging file | Staging file (set by curator at curation time) |
| `created_at` | `xml_writer_agent` | Set to today's date (`YYYY-MM-DD`) on CREATE; never updated | Write-time date |
| `updated_at` | `xml_writer_agent` | Set to today's date on CREATE and on every UPDATE | Write-time date |

---

## Table: `biology`

One row per passport. Row is absent if no biology data is available.

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `passport_id` (FK) | `xml_writer_agent` | Resolved from passport surrogate `id` | Internal |
| `gram_status` | `db_fetch_agent` | `GET https://api.bacdive.dsmz.de/v2/taxon/{genus}/{species_epithet}` → aggregate `morphology_physiology.gram_stain` across strain records (majority rule); map to CV; `null` if heterogeneous or taxon is family-rank | BacDive v2 API |
| `oxygen_tolerance` | `db_fetch_agent` | Same BacDive query → `morphology_physiology.oxygen_tolerance`; majority rule; map to CV | BacDive v2 API |
| `morphology` | `db_fetch_agent` | Same BacDive query → `morphology_physiology.cell_morphology`; majority rule; map to CV | BacDive v2 API |
| `bacdive_url` | `db_fetch_agent` | Species/genus: extract internal BacDive strain ID (`id` field) from the API response → `https://bacdive.dsmz.de/strain/{bacdive_id}`. Family rank: construct advsearch URL → `https://bacdive.dsmz.de/advsearch?fg[0][gc]=OR&fg[0][fl][1][fd]=Family&fg[0][fl][1][fo]=contains&fg[0][fl][1][fv]={FamilyName}&fg[0][fl][1][fvd]=strains-family-1`. Always populated when `preferred_name` is known. | BacDive v2 API response (strain ID); family name for advsearch URL |
| `created_at` | `xml_writer_agent` | Set to today's date on CREATE | Write-time date |
| `updated_at` | `xml_writer_agent` | Set to today's date on CREATE and UPDATE | Write-time date |

**Note:** For taxa at family rank or above, BacDive v2 has no family-level endpoint. `db_fetch_agent` skips biology field fetching for these taxa (gram_status, oxygen_tolerance, morphology, key_traits remain null) but **always writes a `biology` block** with `bacdive_url` populated.

---

## Table: `taxon_tag`

Each row is one list item. `ext_id` meaning depends on `category` (see schema comment).

### category = `synonym`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `db_fetch_agent` | NCBI Taxonomy `efetch` → `<OtherNames><CommonName>` entries only. No synonyms from the paper, BacDive, or background knowledge. Empty list if NCBI has no common names. | NCBI Taxonomy E-utilities |
| `ext_id` | — | Not used for synonyms; always `NULL` | — |

### category = `key_trait`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `db_fetch_agent` | BacDive v2 → `morphology_physiology.observation`; filter to terms present in `CONTROLLED_VOCABULARY.md`; discard free-text entries that do not map | BacDive v2 API |
| `ext_id` | — | Not used; always `NULL` | — |

### category = `primary_niche`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `db_fetch_agent` | BacDive v2 → `isolation_sources_and_natural_habitats.isolation_source`; union across strain records; map to CV | BacDive v2 API |
| `ext_id` (MeSH anatomy ID) | `mesh_agent` | For each niche value, look up the MeSH anatomy descriptor (e.g., `gut` → `D007422`) via NLM E-utilities MeSH search | NLM E-utilities MeSH API |

### category = `reservoir`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `db_fetch_agent` | BacDive v2 → `isolation_sources_and_natural_habitats.host_organism` + `natural_habitat`; map to CV values (`human` / `animal` / `environment`) | BacDive v2 API |
| `ext_id` | — | Not used; always `NULL` | — |

### category = `transmission_route`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Extract only from paper Results and Discussion where the paper's own data or conclusions explicitly describe a transmission route for this taxon. Background statements from Introduction do not qualify. Map to CV. | Paper text (Results/Discussion only) |
| `ext_id` | — | Not used; always `NULL` | — |

### category = `role`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Read paper for explicit role characterisation (e.g., "opportunistic pathogen", "protective commensal"); map to CV; do not infer from association text alone | Paper text (all sections) |
| `ext_id` | — | Not used; always `NULL` | — |

### category = `typical_specimen`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Extract specimen types the paper explicitly associates with clinical isolation or detection of this taxon; map to CV | Paper text (clinical data, Results) |
| `ext_id` (MeSH anatomy ID) | `mesh_agent` | Look up MeSH anatomy descriptor for the specimen type (e.g., `blood` → `D001769`, `stool` → `D005243`) via NLM E-utilities | NLM E-utilities MeSH API |

### category = `risk_context`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Extract patient populations or settings where the taxon is explicitly linked to elevated risk in this paper; map to CV | Paper text (Results/Discussion) |
| `ext_id` | — | Not used; always `NULL` | — |

### category = `bloom_trigger`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Extract only triggers this paper's own data or primary conclusions associate with overgrowth or expansion of this taxon. Introduction background does not qualify. Map to CV. | Paper text (Results/Discussion only) |
| `ext_id` (KEGG Drug ID) | `kegg_agent` | Map drug/trigger name to KEGG Drug D-number via local KEGG flat file mirror (`ligand/drug/drug`) | Local KEGG flat file mirror |

### category = `amr_highlight`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `value` | `entity_extractor_agent` | Extract AMR phenotypes explicitly reported in this paper for this taxon; map to CV | Paper text |
| `ext_id` (CARD ARO ID) | `aro_agent` | Map phenotype name to ARO identifier via local CARD ontology data; fall back to CARD web API if local data unavailable | CARD ontology / CARD web API |

---

## Table: `metabolite`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `passport_id` (FK) | `xml_writer_agent` | Resolved from passport surrogate `id` | Internal |
| `metabolite_name` | `entity_extractor_agent` | Extract metabolite names explicitly reported in this paper for this taxon | Paper text |
| `relationship` | `entity_extractor_agent` | Determine produces / consumes / modifies from paper context | Paper text |
| `kegg_compound_id` | `kegg_agent` | Map metabolite name to KEGG Compound C-number via local KEGG flat file mirror (`ligand/compound/compound`) | Local KEGG flat file mirror |
| `chebi_id` | `kegg_agent` | Map metabolite name to ChEBI ID via local KEGG flat file cross-reference or ChEBI lookup | Local KEGG flat file mirror |
| `created_at` | `xml_writer_agent` | Set to today's date | Write-time date |
| `updated_at` | `xml_writer_agent` | Set to today's date on CREATE and UPDATE | Write-time date |

---

## Table: `paper`

One row per source paper. Populated from `source_paper` in the staging file. Deduped on PMID — `ON DUPLICATE KEY UPDATE` on re-import.

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `pmid` | `paper_analyst_agent` | PMID taken from the PDF filename (authoritative); never searched in the PDF | PDF filename |
| `title` | `paper_analyst_agent` | Extracted from the paper's title page or header | PDF text |
| `authors` | `paper_analyst_agent` | Extracted from the paper; semicolon-separated author list | PDF text |
| `journal` | `paper_analyst_agent` | Extracted from the paper's journal name | PDF text |
| `year` | `paper_analyst_agent` | Publication year extracted from the paper | PDF text |
| `study_design` | `paper_analyst_agent` | Identified from paper methods (e.g., `"prospective cohort"`, `"RCT"`, `"systematic review"`) | PDF text (Methods section) |
| `population` | `paper_analyst_agent` | Study population description extracted from methods or abstract | PDF text |
| `sample_size` | `paper_analyst_agent` | Total sample size reported in the paper; `null` if not reported | PDF text |
| `created_at` | `xml_writer_agent` | Set to today's date on first write | Write-time date |

---

## Table: `passport_pmid`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `passport_id` (FK) | `xml_writer_agent` | Resolved from passport surrogate `id` | Internal |
| `pmid` | `entity_extractor_agent` | The source paper's PMID (taken from the PDF filename). Additional PMIDs may be added if the paper cites prior work as general background evidence for the taxon's clinical relevance. | PDF filename (authoritative PMID source); paper reference list |
| `created_at` | `xml_writer_agent` | Set to today's date | Write-time date |

---

## Table: `association`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `passport_id` (FK) | `xml_writer_agent` | Resolved from passport surrogate `id` | Internal |
| `association_text` | `entity_extractor_agent` | One sentence per distinct clinical claim. Format: `CONDITION: finding.` Maximum 20 words. No statistics, no methodology. Paraphrase — do not quote verbatim. Separate distinct claims into separate rows. | Paper text (Results/Discussion) |
| `content_hash` | `xml_writer_agent` | SHA-256 of lowercased, whitespace-normalised `association_text`. Never provided in staging file — always computed at write time. Used to deduplicate on UPDATE runs. | Computed from `association_text` at write time |
| `evidence_level` | `grading_agent` | One grade assigned per paper based on study design: E3 = multiple cohorts / meta-analysis / guidelines; E2 = single cohort / RCT / case-control; E1 = animal model / in vitro / mechanistic. Applies to all associations from that paper. | Paper methods section |
| `evidence_type` | `entity_extractor_agent` | Study design string matching the paper's design (e.g., `"prospective cohort"`, `"RCT"`). Typically identical to `source_paper.study_design` for single-design papers. | Paper methods section |
| `created_at` | `xml_writer_agent` | Set to today's date | Write-time date |
| `updated_at` | `xml_writer_agent` | Set to today's date on CREATE and UPDATE | Write-time date |

---

## Table: `assoc_ref`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `association_id` (FK) | `xml_writer_agent` | Resolved from association surrogate `id` | Internal |
| `ref_type` | `mesh_agent` / `kegg_agent` | `mesh` for MeSH terms; `kegg_disease` for KEGG Disease IDs | Determined by which agent populates the row |
| `ref_id` (MeSH) | `mesh_agent` | Fetch paper's MeSH annotations from NLM E-utilities using source PMID: `GET .../efetch.fcgi?db=pubmed&id={pmid}&rettype=xml` → `<MeshHeadingList>`; filter to terms relevant to this association's clinical condition | NLM E-utilities PubMed API |
| `ref_id` (KEGG Disease) | `kegg_agent` | Map association condition text to KEGG Disease H-number via local KEGG flat file mirror (`pathway/disease`) | Local KEGG flat file mirror |
| `ref_label` | `mesh_agent` | MeSH preferred term name (human-readable); populated for `mesh` type only; `NULL` for `kegg_disease` | NLM MeSH vocabulary |
| `created_at` | `xml_writer_agent` | Set to today's date | Write-time date |

---

## Table: `assoc_pmid`

| Field | Populated by | Strategy | Source |
|-------|-------------|----------|--------|
| `association_id` (FK) | `xml_writer_agent` | Resolved from association surrogate `id` | Internal |
| `pmid` | `entity_extractor_agent` | Source paper PMID at minimum. If the paper cites a specific prior study as direct evidence for this individual association, that PMID is included too. | PDF filename (source PMID); paper in-text citations |
| `created_at` | `xml_writer_agent` | Set to today's date | Write-time date |

---

## Summary by Agent

| Agent | Tables written to | Field count |
|-------|------------------|-------------|
| `paper_analyst_agent` | `passport`, `paper` | `preferred_name`, `taxon_rank`, `ncbi_taxid`; all `paper` fields |
| `db_fetch_agent` | `passport`, `biology`, `taxon_tag` | `domain`, `lineage`; `gram_status`, `oxygen_tolerance`, `morphology`; `synonym`, `key_trait`, `primary_niche.value`, `reservoir` |
| `entity_extractor_agent` | `passport`, `taxon_tag`, `metabolite`, `association`, `assoc_pmid`, `passport_pmid` | `is_pathobiont`; `transmission_route`, `role`, `typical_specimen.value`, `risk_context`, `bloom_trigger.value`, `amr_highlight.value`; all metabolite fields; `association_text`, `evidence_type`; PMIDs |
| `grading_agent` | `association` | `evidence_level` |
| `mesh_agent` | `taxon_tag`, `assoc_ref` | `primary_niche.ext_id`, `typical_specimen.ext_id`; `ref_id` + `ref_label` for mesh refs |
| `kegg_agent` | `taxon_tag`, `metabolite`, `assoc_ref` | `bloom_trigger.ext_id`; `kegg_compound_id`, `chebi_id`; `ref_id` for kegg_disease refs |
| `aro_agent` | `taxon_tag` | `amr_highlight.ext_id` |
| `xml_writer_agent` | All tables | All surrogate PKs, all FKs, `content_hash`, all `created_at` / `updated_at` timestamps |
| `mca-xml-update` orchestrator | `passport` | `passport_id`, `last_reviewed` |
| `xml2sql.py` | `meta` | `db_version` |

---

## Missing Holes and Open Issues

### Fields with no automated source (currently always null)

| Field | Table | Gap |
|-------|-------|-----|
| `chebi_id` | `metabolite` | ChEBI lookup not implemented in `kegg_agent` |
| `amr_highlight.ext_id` (ARO ID) | `taxon_tag` | `aro_agent` is best-effort; local CARD data path not confirmed |
| `bloom_trigger.ext_id` (KEGG Drug ID) | `taxon_tag` | Requires exact drug name match against KEGG Drug flat file; fails for non-standard names |
