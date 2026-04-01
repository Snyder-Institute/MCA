# CONTROLLED_VOCABULARY.md — MCA Controlled Vocabulary Reference

Used by `agents/ENTITY_EXTRACTOR_AGENT.md` to ensure extracted field values match the standardized terms used across all MCA Taxon Passports. All extracted values must be drawn from the lists below. If a paper uses a term not on the list, map it to the closest match and note the original term in parentheses.

---

## Identity Fields

### Taxon Rank
Allowed values:
- `kingdom`
- `phylum`
- `class`
- `order`
- `family`
- `genus`
- `species`
- `strain`

### Passport ID Format
`MCA-[DOMAIN]-[NNNNNN]`

| Domain Code | Organism Type |
|-------------|---------------|
| `BAC` | Bacteria |
| `FUN` | Fungi |
| `VIR` | Viruses |
| `ARC` | Archaea |
| `MIC` | Mixed or unknown domain |

---

## Biology Fields

### Gram Status
Allowed values:
- `gram-positive`
- `gram-negative`
- `gram-variable`
- `not applicable` *(for fungi, viruses, archaea)*
- `unknown`

### Oxygen Tolerance
Allowed values:
- `aerobe`
- `facultative anaerobe`
- `obligate anaerobe`
- `microaerophile`
- `aerotolerant anaerobe`
- `not applicable`
- `unknown`

### Morphology
Allowed values:
- `coccus`
- `bacillus (rod)`
- `coccobacillus`
- `spirochete`
- `vibrio`
- `filamentous`
- `yeast`
- `mold`
- `dimorphic fungus`
- `not applicable`
- `unknown`

---

## Ecology Fields

### Primary Niches
Free-text list, but standardize body site terms using the following:

| Preferred Term | Acceptable Synonyms |
|----------------|---------------------|
| `gut` | intestine, colon, large intestine, GI tract |
| `small intestine` | duodenum, jejunum, ileum |
| `oral cavity` | mouth, oral microbiome |
| `skin` | cutaneous |
| `vagina` | vaginal microbiome |
| `lung` | respiratory tract, pulmonary |
| `urinary tract` | bladder, urethra |
| `nasopharynx` | nasal cavity, upper respiratory |
| `bloodstream` | blood |
| `liver` | hepatic |
| `environment` | soil, water, surfaces |

### Reservoirs
Allowed values (can be multiple):
- `human`
- `animal`
- `environment`
- `food`
- `unknown`

### Transmission Routes
Free-text list, standardize using:
- `fecal-oral`
- `contact transmission` *(direct skin/surface)*
- `airborne`
- `droplet`
- `foodborne`
- `waterborne`
- `healthcare-associated` *(nosocomial)*
- `vertical transmission` *(mother to infant)*
- `sexual transmission`
- `unknown`

---

## Clinical Profile Fields

### Pathobiont Status
Allowed values (select one):
- `yes`
- `no`
- `context dependent`
- `unknown`

### Clinical Roles
Allowed values (can be multiple):
- `opportunistic pathogen`
- `primary pathogen`
- `protective commensal`
- `commensal`
- `probiotic candidate`
- `biofilm former`
- `coloniser`
- `unknown`

### Typical Specimen Types
Allowed values (can be multiple):
- `stool`
- `blood`
- `urine`
- `sputum`
- `bronchoalveolar lavage (BAL)`
- `wound swab`
- `vaginal swab`
- `skin swab`
- `cerebrospinal fluid (CSF)`
- `biopsy`
- `nasopharyngeal swab`
- `unknown`

### Bloom Triggers
Free-text list, standardize using:
- `antibiotic exposure`
- `immunosuppression`
- `inflammation`
- `dietary change`
- `dysbiosis`
- `hospitalization`
- `surgery`
- `chemotherapy`
- `proton pump inhibitor (PPI) use`
- `unknown`

### Risk Contexts
Free-text list, standardize using:
- `immunocompromised patients`
- `ICU / critical care`
- `post-antibiotic`
- `inflammatory bowel disease (IBD)`
- `irritable bowel syndrome (IBS)`
- `colorectal cancer`
- `type 2 diabetes`
- `obesity`
- `neonates / premature infants`
- `elderly`
- `post-surgical`
- `solid organ transplant recipients`
- `HIV/AIDS`
- `unknown`

### AMR Highlights
Free-text list, standardize using:
- `ESBL-producing` *(Extended-spectrum beta-lactamase)*
- `CRE` *(Carbapenem-resistant Enterobacterales)*
- `MRSA` *(Methicillin-resistant Staphylococcus aureus)*
- `VRE` *(Vancomycin-resistant Enterococcus)*
- `CRKP` *(Carbapenem-resistant Klebsiella pneumoniae)*
- `multidrug-resistant (MDR)`
- `pan-drug-resistant (PDR)`
- `none documented`
- `unknown`

---

## Evidence Fields

### Evidence Grade
Allowed values (see `references/GRADING_CRITERIA.md` for full rules):
- `E3` — Strong human clinical evidence
- `E2` — Moderate human evidence
- `E1` — Limited / preliminary
- `UNCERTAIN` — Study design ambiguous or not reported

---

## Mapping Guidance

When a paper uses non-standard terminology:
1. Map to the closest controlled term above
2. Record the original term from the paper in parentheses in the extracted value
   - Example: paper says "large bowel" → use `gut (large bowel)`
3. If no reasonable mapping exists, use `unknown` and flag for user review
