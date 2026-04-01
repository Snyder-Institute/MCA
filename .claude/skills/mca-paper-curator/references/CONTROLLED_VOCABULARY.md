# CONTROLLED_VOCABULARY.md — MCA Controlled Vocabulary Reference

Used by `agents/ENTITY_EXTRACTOR_AGENT.md` to ensure extracted field values match the standardized terms used across all MCA Taxon Passports. All extracted values must be drawn from the lists below. If a paper uses a term not on the list, map it to the closest match and note the original term in parentheses.

---

## Identity Fields

### Domain
Allowed values:
- `Bacteria`
- `Archaea`
- `Fungi`
- `Virus`
- `Eukaryote`

### Taxon Rank
Allowed values:
- `family`
- `genus`
- `species`
- `strain`
- `clade`

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

### Key Traits
Extract only traits the paper explicitly attributes to this taxon. Do not add traits from background knowledge.

Standardized terms:
- `spore-forming`
- `biofilm-forming`
- `toxin-producing`
- `butyrate-producing`
- `short-chain fatty acid (SCFA) producer`
- `mucin-degrading`
- `cellulose-degrading`
- `hydrogen-producing`
- `sulfate-reducing`
- `nitrogen-fixing`
- `antibiotic-producing`

If the paper uses a term not on this list, map to the closest match and note the original in parentheses. If no reasonable mapping exists, use the paper's exact term and flag in `extraction_notes`.

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

**Decision rule:**
- `yes` — paper explicitly labels the taxon as a pathobiont, or demonstrates it causes infection/disease in humans in this paper's own data. **Explicit paper language takes priority over background biological knowledge** — if the paper calls the taxon a pathobiont, use `yes` even if the taxon is also a known gut commensal.
- `no` — paper explicitly characterises the taxon as commensal, protective, or non-pathogenic
- `context dependent` — paper states the taxon can be both beneficial and harmful depending on host state or conditions, **and does not explicitly label it a pathobiont**
- `unknown` — paper does not characterise pathobiont status; use as default when no explicit statement is present

**Priority:** `yes` (explicit label) > `context dependent` (inferred from biology) > `unknown`. When explicit paper language conflicts with background knowledge, always follow the paper and flag the conflict in `extraction_notes`.

For UPDATE actions: only propose a change if the paper provides an explicit characterisation. If overwriting a non-null, non-`unknown` existing value, flag in `extraction_notes` and require human review before applying.

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

**Mapping guidance:**
- `opportunistic pathogen` — normally commensal but can cause infection in vulnerable hosts (immunocompromised, ICU, post-surgical); paper explicitly describes disease-causing potential in at-risk populations
- `primary pathogen` — causes disease in immunocompetent hosts; paper demonstrates direct pathogenic role without requiring host compromise
- `protective commensal` — paper explicitly describes a protective, beneficial, or colonisation-resistance role; depletion is associated with disease risk
- `commensal` — paper characterises as normal flora without assigning a protective or pathogenic role
- `probiotic candidate` — paper explicitly evaluates or proposes the taxon for probiotic or therapeutic use
- `biofilm former` — paper explicitly describes biofilm formation as a clinically or ecologically relevant feature
- `coloniser` — paper describes transient or early colonisation without further clinical characterisation
- `unknown` — paper does not assign a clinical role

A taxon may have multiple roles (e.g., `commensal` + `opportunistic pathogen`). Assign all roles the paper explicitly supports.

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
3. If no reasonable mapping exists:
   - For **closed-vocabulary fields** (`gram_status`, `oxygen_tolerance`, `morphology`, `is_pathobiont`, `clinical_roles`, `reservoirs`, `typical_specimens`, `amr_highlights`): use `unknown` and flag in `extraction_notes`
   - For **free-text list fields** (`primary_niches`, `transmission_routes`, `bloom_triggers`, `risk_contexts`, `key_traits`): use the paper's exact term and flag in `extraction_notes`
