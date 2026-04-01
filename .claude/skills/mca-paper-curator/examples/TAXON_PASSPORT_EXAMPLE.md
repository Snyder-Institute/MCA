# TAXON_PASSPORT_EXAMPLE.md — Filled Passport Example

Demonstrates a complete Taxon Passport entry for ***Clostridioides difficile*** as an example of expected field values and formatting. This example represents a CREATE action.

---

## Identity

| Field | Value |
|-------|-------|
| Passport ID | MCA-BAC-000007 |
| Preferred Name | Clostridioides difficile |
| Taxon Rank | species |
| Domain | Bacteria |
| Lineage | Bacteria \| Bacillota \| Clostridia \| Eubacteriales \| Peptostreptococcaceae \| Clostridioides \| Clostridioides difficile |
| NCBI TaxID | 1496 |
| Synonyms | Clostridium difficile |
| Last Reviewed | 2026-03-31 |

---

## Biology

| Field | Value |
|-------|-------|
| Gram Status | gram-positive |
| Oxygen Tolerance | obligate anaerobe |
| Morphology | bacillus (rod) |
| Key Traits | spore-forming; toxin-producing (TcdA, TcdB); capable of prolonged environmental persistence via spores |

---

## Ecology

| Field | Value |
|-------|-------|
| Primary Niches | gut |
| Reservoirs | human; environment; animal |
| Transmission Routes | fecal-oral; healthcare-associated; contact transmission (spore-contaminated surfaces) |

---

## Clinical Profile

| Field | Value |
|-------|-------|
| Pathobiont Status | yes |
| Clinical Roles | opportunistic pathogen; coloniser |
| Typical Specimen Types | stool |
| Bloom Triggers | antibiotic exposure; hospitalization; immunosuppression; proton pump inhibitor (PPI) use |
| Risk Contexts | post-antibiotic; ICU / critical care; elderly; immunocompromised patients; solid organ transplant recipients |
| AMR Highlights | multidrug-resistant (MDR); fluoroquinolone-resistant strains documented (e.g., ribotype 027) |

---

## Clinical Associations

### Association 1
| Field | Value |
|-------|-------|
| Association Text | *Clostridioides difficile* infection (CDI) is the leading cause of healthcare-associated infectious diarrhoea in adults, with recurrence rates of 20–30% after first-line treatment. |
| Evidence Grade | E3 |
| Evidence Rationale | Supported by multiple systematic reviews and international clinical guidelines (IDSA/SHEA). Broadly accepted in clinical practice with high-quality evidence. No meaningful caveats at the guideline level. |
| PMID(s) | 28085506, 31325312 |

### Association 2
| Field | Value |
|-------|-------|
| Association Text | Gut microbiome diversity loss, particularly depletion of *Lachnospiraceae* and *Ruminococcaceae*, is associated with increased susceptibility to CDI and recurrence. |
| Evidence Grade | E2 |
| Evidence Rationale | Supported by multiple prospective cohort and case-control studies in hospitalised patients. Human observational evidence with defined clinical outcomes qualifies for E2. Caveats: heterogeneity in microbiome profiling methods across studies. |
| PMID(s) | 24912484, 29180460 |

### Association 3
| Field | Value |
|-------|-------|
| Association Text | Faecal microbiota transplantation (FMT) significantly reduces CDI recurrence compared to vancomycin alone. |
| Evidence Grade | E3 |
| Evidence Rationale | Supported by multiple RCTs and a Cochrane systematic review. High-quality evidence from randomised trials with a defined clinical endpoint. Caveats: variability in donor selection and preparation protocols across trials. |
| PMID(s) | 23323867, 31299178 |

---

## General Evidence (Taxon-Level PMIDs)

PMIDs supporting the passport as a whole:

- 28085506
- 31325312

---

## Extraction Notes

- Preferred name updated from *Clostridium difficile* (legacy) to *Clostridioides difficile* (current valid name per NCBI Taxonomy as of 2019)
- Synonym "Clostridium difficile" sourced from NCBI Taxonomy Common names for TaxID 1496
- Ribotype 027 (NAP1/BI) noted under AMR highlights as a clinically significant hypervirulent strain
