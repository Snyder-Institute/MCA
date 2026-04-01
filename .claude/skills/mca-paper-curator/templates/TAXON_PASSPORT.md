# TAXON_PASSPORT.md — Blank Taxon Passport Template

Used by `agents/ENTITY_EXTRACTOR_AGENT.md` during extraction. Fill in all fields extractable from the paper. Leave fields as `null` if the paper does not report them. Do not infer or fabricate values.

All field values must conform to `references/CONTROLLED_VOCABULARY.md`.

---

## Identity

| Field | Value |
|-------|-------|
| Passport ID | *(assigned on CREATE; existing ID on UPDATE)* |
| Preferred Name | |
| Taxon Rank | |
| Domain | *(Bacteria / Archaea / Fungi / Virus / Eukaryote)* |
| Lineage | *(phylum \| class \| order \| family \| genus \| species — pipe-separated)* |
| NCBI TaxID | *(integer)* |
| Synonyms | *(semicolon-separated)* |
| Last Reviewed | *(YYYY-MM-DD)* |

---

## Biology

| Field | Value |
|-------|-------|
| Gram Status | |
| Oxygen Tolerance | |
| Morphology | |
| Key Traits | *(one per line)* |

---

## Ecology

| Field | Value |
|-------|-------|
| Primary Niches | *(comma-separated)* |
| Reservoirs | *(comma-separated)* |
| Transmission Routes | *(one per line)* |

---

## Clinical Profile

| Field | Value |
|-------|-------|
| Pathobiont Status | *(yes / no / context dependent / unknown)* |
| Clinical Roles | *(semicolon-separated)* |
| Typical Specimen Types | *(semicolon-separated)* |
| Bloom Triggers | *(semicolon-separated)* |
| Risk Contexts | *(semicolon-separated)* |
| AMR Highlights | *(semicolon-separated, or "none documented")* |

---

## Metabolites

*One block per metabolite relationship reported in the paper. Leave section blank if none.*

| Field | Value |
|-------|-------|
| Metabolite Name | |
| Relationship | *(produces / consumes / modifies)* |
| KEGG Compound ID | *(populated in Phase 2; leave blank)* |
| ChEBI ID | *(populated in Phase 2; leave blank)* |

---

## Clinical Associations

*One block per association extracted from the paper.*

### Association 1
| Field | Value |
|-------|-------|
| Association Text | *(free text — the clinical claim)* |
| Evidence Type | *(study design — e.g., prospective cohort, RCT, mouse model)* |
| Evidence Grade | *(E1 / E2 / E3 / UNCERTAIN — from grading agent)* |
| Evidence Rationale | *(from grading agent)* |
| PMID(s) | *(comma-separated)* |

### Association 2
| Field | Value |
|-------|-------|
| Association Text | |
| Evidence Type | |
| Evidence Grade | |
| Evidence Rationale | |
| PMID(s) | |

*(add more blocks as needed)*

---

## General Evidence (Taxon-Level PMIDs)

PMIDs supporting the passport as a whole (not tied to a specific clinical association):

- 

---

## Extraction Notes

*Flag any ambiguities, unmapped terms, or fields requiring user review.*

-
