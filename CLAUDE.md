# CLAUDE.md — Microbial Clinical Atlas (MCA)

## Project overview

MCA is a curated clinical knowledge base for the human microbiome. It organizes microbial information into standardized **Taxon Passports** — structured records capturing taxonomic identity, ecological context, clinical associations, and evidence-linked references (PMIDs). The goal is to support reproducible interpretation of microbiome sequencing data in clinical and translational research.

**Maintained by:** Bioinformatics Hub
**Current version:** v0.1 (proof of concept)  
**License:** MIT

---

## Tech stack

- **Backend:** PHP 7.4+ with PDO (MySQL)
- **Database:** MySQL (InnoDB, UTF-8), star schema centered on `mca_taxon_passport`
- **Frontend:** Vanilla HTML/CSS/JS (no frameworks); Google Fonts (Montserrat, Roboto)
- **Deployment:** LAMP stack; web root is `/web`
- **Export:** XMLWriter-based versioned XML dumps in `web/data/`

---

## Directory layout

```
MCA/
├── web/                        # Main web application
│   ├── index.php               # Homepage with live search autocomplete
│   ├── passport.php            # Individual taxon passport detail view
│   ├── passports.php           # Browse/table view of all taxa
│   ├── search.php              # Search results page
│   ├── search_handler.php      # AJAX search endpoint
│   ├── about.php               # Database stats and curation overview
│   ├── export_xml.php          # Generates versioned XML exports
│   ├── glossary.php            # Controlled vocabulary glossary
│   ├── header.php / footer.php # Shared page templates
│   ├── db_connect.php          # Credentials (gitignored — do not commit)
│   ├── db_connect_template.php # Copy this to db_connect.php and fill in credentials
│   ├── css/style.css           # Main stylesheet
│   ├── images/                 # Logo and favicon
│   └── data/                   # Versioned XML exports (e.g., MCA_DB_v0.1.xml)
├── database/
│   ├── MCA_create_database.sql.gz  # Full schema definition
│   └── MCA_dump_v0.1.sql.gz        # Sample data dump
├── staging/                    # Staging JSON files from mca-paper-curator (gitignored)
│   └── YYYY-MM-DD_taxon-name.json  # One file per taxon per curation run
└── .claude/
    └── skills/
        ├── mca-paper-curator/  # Skill 1: paper → staging JSON (7-agent, 4-phase pipeline)
        └── mca-xml-update/     # Skill 2: staging JSON → XML database
```

---

## Primary entities in the MCA knowledge base

MCA is fundamentally a KB about **linking taxa to clinical and biological features** through structured, evidence-backed records. The primary entities and their relationships are:

### 1. Taxon (core entity)
A curated microbial organism — bacterium, fungus, virus, or archaeon — at any taxonomic rank (family, genus, species, strain). Each taxon has exactly one **Taxon Passport**.

- Identified by a stable `passport_id` (format: `MCA-[DOMAIN]-[NNNNNN]`, e.g. `MCA-BAC-000001`)
- Linked to NCBI Taxonomy via `ncbi_taxid`
- Can have multiple **Synonyms** (historical names, aliases)

### 2. Taxon Passport (record entity)
The central structured record for a taxon. A passport is versioned and reviewed over time. It organizes all knowledge about a taxon into four feature groups:

**Biology** — intrinsic microbiological properties:
- Gram status, oxygen tolerance, morphology
- Key traits (e.g., spore-forming, biofilm-producing)

**Ecology** — environmental and host context:
- Primary niches (body sites or environments)
- Reservoirs (human, animal, environment)
- Transmission routes (how the organism is acquired)

**Clinical profile** — clinically relevant features:
- Pathobiont status (`yes` / `no` / `context dependent` / `unknown`)
- Clinical roles (e.g., opportunistic pathogen, protective commensal)
- Typical specimen types (e.g., blood, stool, respiratory)
- Bloom triggers (conditions enabling overgrowth, e.g., antibiotic exposure)
- Risk contexts (vulnerable populations or settings, e.g., ICU, immunosuppressed)
- AMR highlights (notable resistance phenotypes, e.g., ESBL, CRE)

**Evidence** — general PMID citations supporting the passport as a whole

### 3. Clinical Association (claim entity)
An individual, evidence-graded claim linking a taxon to a specific clinical condition or outcome (e.g., "associated with increased risk of CDI recurrence"). Each association is:
- Linked to exactly one Taxon Passport via `passport_id`
- Graded by evidence level:
  - **E3** — Strong human clinical evidence (guidelines, meta-analyses, systematic reviews, or multiple independent human cohorts within a single paper)
  - **E2** — Moderate human evidence (single cohort, single RCT, case-control, or cross-sectional study)
  - **E1** — Limited / preliminary (animal models, in vitro studies, case reports, mechanistic work)
- Supported by one or more PMIDs

### 4. Evidence / PMID (support entity)
A PubMed citation (PMID) that backs a specific claim. PMIDs attach at two levels:
- **Taxon-level**: general references supporting the overall passport (`mca_taxon_evidence_pmid`)
- **Claim-level**: specific references for each clinical association (`mca_clinical_association_pmid`)

### Entity relationship summary

```
Taxon (1) ──── (1) Taxon Passport
                    │
                    ├── (N) Biology / Ecology / Clinical feature lists
                    ├── (N) Synonyms
                    ├── (N) Taxon-level PMIDs
                    └── (N) Clinical Associations
                                │
                                └── (N) Claim-level PMIDs
```

The KB's core purpose is to make the links between **taxa**, **clinical features**, and **supporting evidence** explicit, controlled, and reproducible across studies.

---

## Database schema overview

The schema uses a star schema: `mca_taxon_passport` is the central entity, with many 1:N satellite tables.

**Core table:**
- `mca_taxon_passport` — one row per taxon; stable `passport_id` (format: `MCA-BAC-000001`), `preferred_name`, `taxon_rank`, `lineage`, `ncbi_taxid`, `is_pathobiont`, `last_reviewed`, `version`

**Taxon attribute tables (1:N):**
- `mca_taxon_synonym`, `mca_taxon_biology`, `mca_taxon_key_trait`
- `mca_taxon_primary_niche`, `mca_taxon_reservoir`, `mca_taxon_transmission_route`
- `mca_taxon_role`, `mca_taxon_typical_specimen`, `mca_taxon_risk_context`
- `mca_taxon_bloom_trigger`, `mca_taxon_amr_highlight`

**Evidence tables:**
- `mca_taxon_evidence_pmid` — PMIDs at the taxon level
- `mca_clinical_association` — individual clinical claim records linked to `passport_id`
- `mca_clinical_association_pmid` — PMIDs per clinical claim (many-to-many)

**Evidence grading:** E1 (limited/preliminary) → E2 (moderate) → E3 (strong clinical)

---

## Local setup

1. Extract and import schema: `gunzip database/MCA_create_database.sql.gz && mysql < MCA_create_database.sql`
2. Import data: `gunzip database/MCA_dump_v0.1.sql.gz && mysql MCA < MCA_dump_v0.1.sql`
3. Configure DB credentials: `cp web/db_connect_template.php web/db_connect.php` then edit (host=localhost, user=mca, db=MCA)
4. Point web server root to `/web`
5. Optionally regenerate XML export by running `export_xml.php`

---

## Key conventions

- **Never commit `web/db_connect.php`** — it contains credentials and is gitignored.
- `passport_id` values are stable identifiers; do not reassign or recycle them.
- All SQL queries use PDO prepared statements — maintain this pattern to prevent SQL injection.
- XML exports are versioned by the `version` field on `mca_taxon_passport`; regenerate after data changes.
- Evidence claims must be accompanied by at least one PMID.
- Controlled vocabulary terms (roles, niches, gram status, etc.) should match the glossary in `glossary.php`.

---

## Project aims (for context)

1. **Standardize** microbial knowledge into consistent Taxon Passports with stable identifiers.
2. **Link evidence** explicitly — every clinical claim is tied to PMIDs and an evidence grade.
3. **Support interpretation** of microbiome signals in clinical/translational settings.
4. **Enable reuse** via versioned, structured exports (XML) for downstream tools and web apps.
