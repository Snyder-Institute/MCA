# MCA Entity & Ontology Mapping

**Status:** Design notes — work in progress  
**Last updated:** 2026-04-01

---

## Overview

MCA links two primary real-world entities in every clinical association:
- **Microbial entity** → standardized by NCBI TaxID
- **Clinical entity** → to be standardized by MeSH + KEGG Disease

Goal: every entity type in MCA should have a stable, external identifier so records are machine-readable and linkable to other biomedical resources.

---

## 1. Taxon (core entity)

| Field | Current state | Standard ID |
|---|---|---|
| preferred_name | text | — |
| ncbi_taxid | NCBI TaxID ✓ | https://www.ncbi.nlm.nih.gov/taxonomy |
| lineage | text (pipe-separated) | — |
| synonyms | text | LPSN (prokaryote names: lpsn.dsmz.de) |

---

## 2. Biology attributes

Currently: free-text controlled vocabulary, no external IDs.

| Field | Example values | Candidate standard |
|---|---|---|
| gram_status | positive / negative / variable | None needed (closed vocab) |
| oxygen_tolerance | aerobic / anaerobic / facultative / microaerophilic | None needed (closed vocab) |
| morphology | rod / coccus / spirillum / filament | PATO (Phenotype & Trait Ontology) |
| key_traits | spore-forming, biofilm-producing, toxin-producing | Gene Ontology (GO) biological process terms |

---

## 3. Ecology attributes

Currently: free-text, no external IDs.

| Field | Example values | Candidate standard |
|---|---|---|
| primary_niches | gut, oral, skin, respiratory, urogenital | **UBERON** (anatomical ontology) or MeSH anatomy |
| reservoirs | human, animal, environment | NCBI TaxID (for host organisms) |
| transmission_routes | fecal-oral, airborne, contact, vertical | MeSH |

---

## 4. Clinical profile attributes

Currently: free-text, no external IDs.

| Field | Example values | Candidate standard |
|---|---|---|
| clinical_roles | opportunistic pathogen, protective commensal, toxin producer | Disease Ontology (DO) / MeSH |
| typical_specimens | stool, blood, respiratory, urine, CSF | UBERON / MeSH anatomy |
| bloom_triggers | antibiotic exposure, immunosuppression, dysbiosis | **KEGG Drug** / MeSH (D000900 = Anti-Bacterial Agents) |
| risk_contexts | ICU, immunosuppressed, elderly, post-surgical | MeSH (patient/population descriptors) |
| amr_highlights | ESBL, CRE, VRE, linezolid resistance | **CARD / ARO** (Antibiotic Resistance Ontology: card.mcmaster.ca) |

---

## 5. Clinical Association (claim entity)

| Field | Current state | Candidate standard |
|---|---|---|
| association_text | free-text narrative | — |
| evidence_grade | E1 / E2 / E3 / UNCERTAIN | internal controlled vocab |
| **disease / condition** | embedded in free text — NOT structured | **MeSH** + **KEGG Disease** |
| pmids | PubMed IDs ✓ | (add DOI as secondary?) |

### Proposed addition: `mesh_terms` array per association
```json
"mesh_terms": [
  { "term": "Obesity", "mesh_id": "D009765" },
  { "term": "Triglycerides", "mesh_id": "D014280" }
]
```

### Proposed addition: `kegg_disease_ids` array per association
```json
"kegg_disease_ids": ["H00409", "H01593"]
```

MeSH browser: https://meshb.nlm.nih.gov  
KEGG Disease: https://www.genome.jp/kegg/disease/

---

## 6. Metabolites — NOT YET IN SCHEMA ⚠️

Metabolites are not currently tracked in MCA. This is a significant gap for microbiome context, since many microbial–disease links are mediated by metabolites (butyrate, SCFAs, bile acids, TMAO, urolithins, etc.).

### Design decision needed:
- **Option A:** Metabolites as satellite entries on taxon passports (`mca_taxon_metabolite` table)  
  → "This taxon produces/consumes these metabolites"
- **Option B:** Metabolites as a first-class entity (own records, like taxon passports)  
  → Richer; allows metabolite-centric views and metabolite–disease links
- **Option C:** Metabolites embedded in clinical associations only  
  → Simplest; but loses producer/consumer context

### Candidate standard IDs for metabolites:
| Database | Scope | Example |
|---|---|---|
| **KEGG Compound** | metabolic reactions, pathways | C00246 = butyric acid |
| **ChEBI** (EBI) | chemical entities of biological interest | CHEBI:17968 = butyrate |
| **HMDB** | human metabolome focus | HMDB0000039 = butyric acid |
| **PubChem CID** | broadest chemical coverage | CID 264 = butyric acid |

KEGG Compound is preferred if KEGG integration is already planned for KEGG Disease and KEGG Drug.

---

## 7. KEGG integration plan (proposed)

User will provide KEGG DB. Candidate KEGG resources to link:

| KEGG resource | MCA use case | Links to |
|---|---|---|
| **KEGG Disease** | clinical association conditions | `mca_clinical_association` |
| **KEGG Drug** | antibiotics in bloom_triggers; drugs in risk_contexts | `mca_taxon_bloom_trigger`, associations |
| **KEGG Compound** | metabolites produced/consumed by taxon | new `mca_taxon_metabolite` (TBD) |
| **KEGG Pathway** | metabolic pathways (e.g., butyrate biosynthesis) | new entity (TBD) |
| **KEGG Orthology (KO)** | functional gene/enzyme annotations | new entity (TBD) |
| **KEGG Module** | metabolic modules | new entity (TBD) |

---

## Priority order for implementation

| Priority | Entity | ID to add | Schema impact |
|---|---|---|---|
| 1 | Clinical condition (in associations) | MeSH + KEGG Disease | New field in `mca_clinical_association` |
| 2 | Drugs/antibiotics (bloom_triggers) | KEGG Drug or MeSH | New field in `mca_taxon_bloom_trigger` |
| 3 | **Metabolites (not in schema yet)** | KEGG Compound + ChEBI | New table(s) — design decision needed |
| 4 | Body sites (niches, specimens) | UBERON or MeSH anatomy | New field in niche/specimen tables |
| 5 | AMR phenotypes | CARD / ARO | New field in `mca_taxon_amr_highlight` |
| 6 | Key traits | GO terms | New field in `mca_taxon_key_trait` |
| 7 | Transmission routes, reservoirs | MeSH | New fields in ecology tables |

---

## Next steps (pick up here next session)

These are the open design decisions that must be resolved before any schema changes or staging file format updates are made:

1. **Metabolite architecture** — Should metabolites be a first-class entity (Option B: own records) or satellite entries on taxon passports (Option A: `mca_taxon_metabolite` table)? Option B is richer but requires more schema work. Decide before touching the DB or staging format.

2. **KEGG integration mode** — Is the plan to mirror a local KEGG DB (user will provide), or link out to KEGG REST API at query time? This affects whether KEGG IDs are just stored as strings vs. whether we can do local lookups during curation.

3. **MeSH terms: required or optional?** — Should `mesh_terms` become a required field in new clinical associations going forward (enforced by the paper-curator skill), or remain optional/best-effort? Recommend: required for E2/E3, optional for E1.

4. **Body site identifier: UBERON vs MeSH anatomy** — UBERON is more granular and ontologically richer; MeSH anatomy is PubMed-native and more familiar to clinicians. Pick one for `primary_niches` and `typical_specimens`. Both `primary_niches` and `typical_specimens` should use the same choice.

5. **Implementation order** — Suggested sequence once decisions above are made:
   - Step 1: Add `mesh_terms` + `kegg_disease_ids` to clinical associations (staging schema + DB)
   - Step 2: Add `kegg_drug_id` to bloom_triggers
   - Step 3: Design metabolite entity (depends on decision #1)
   - Step 4: Add body site IDs to niches/specimens (depends on decision #4)
   - Step 5: Add CARD/ARO IDs to amr_highlights
