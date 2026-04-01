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
| Lineage | *(kingdom \| phylum \| class \| order \| family \| genus \| species)* |
| NCBI TaxID | |
| Synonyms | *(semicolon-separated)* |
| Last Reviewed | *(YYYY-MM-DD)* |
| Version | |

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

## Clinical Associations

*One block per association extracted from the paper.*

### Association 1
| Field | Value |
|-------|-------|
| Association Text | *(free text — the clinical claim)* |
| Evidence Grade | *(E1 / E2 / E3 / UNCERTAIN — from grading agent)* |
| Evidence Rationale | *(from grading agent)* |
| PMID(s) | *(comma-separated)* |

### Association 2
| Field | Value |
|-------|-------|
| Association Text | |
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
