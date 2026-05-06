# CLAUDE.md — MCA iOS App

## Project overview

MCA (Microbial Clinical Atlas) is an iPhone companion app for the MCA knowledge base. It has three tabs:

1. **Passports tab** — Offline SQLite browser of curated microbial taxon passports with bookmarks
2. **Search tab** — KEGG pathway search with unified search bar (pathway/taxon/disease autocomplete), powered by a bundled JSON index subset
3. **About tab** — Database stats, curation pipeline, acknowledgements

**Extractor tab** (hidden, code retained) — Paper-to-passport analyzer using Claude API. Hidden from the TabView due to App Store restrictions on BYOK API key models. All source files remain in the project for future re-enablement via server proxy.

**Maintained by:** Bioinformatics Hub, Snyder Institute, Cumming School of Medicine, University of Calgary
**Contact:** bioinformatics@ucalgary.ca
**App Store:** https://apps.apple.com/app/microbial-clinical-atlas/id6761735200
**Web counterpart:** [MCA web app](https://github.com/Snyder-Institute/MCA) — the iOS app mirrors the web's passport.php layout

---

## Tech stack & constraints

- **Framework:** SwiftUI (iOS 17+)
- **Database:** SQLite3 via raw C API — bundled read-only (`journal_mode=delete`, NOT WAL)
- **No external packages** — only Apple frameworks: SwiftUI, Foundation, SQLite3, PDFKit, MessageUI, Security
- **Auto-inclusion:** `PBXFileSystemSynchronizedRootGroup` — any file placed in `MCA/MCA/` is automatically included in the Xcode project; no need to edit `project.pbxproj`
- **`project.pbxproj` edits** — limited to `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` bumps only. All other changes (build settings, Info.plist keys, targets) must be made via the Xcode UI

---

## Directory layout

```
MCA/                            # Monorepo root (web + database + iOS)
├── iOS/                        # ← This subfolder (iOS app)
│   ├── MCA/
│   │   ├── MCA.xcodeproj/
│   │   └── MCA/                          # All source files here (auto-included)
│   │       ├── MCAApp.swift              # App entry point
│   │       ├── ContentView.swift         # TabView root (Passports, Search, About)
│   │       │
│   │       │── # Passports tab
│   │       ├── PassportListView.swift    # Browse/search list with bookmarks
│   │       ├── PassportDetailView.swift  # Full passport detail (mirrors passport.php)
│   │       ├── PassportModels.swift      # Passport, Biology, TaxonTag, Metabolite, Association, Paper, RelatedTaxon
│   │       ├── DatabaseManager.swift     # Singleton SQLite reader (raw C API)
│   │       ├── GlossaryView.swift        # Field glossary (accessible from passport toolbar)
│   │       │
│   │       │── # Search tab
│   │       ├── PathwaySearchView.swift   # Unified search bar with pathway/taxon/disease results
│   │       ├── PathwayIndex.swift        # Codable structs + loader for KEGG pathway JSON index
│   │       ├── kegg_pathway_index.json   # Bundled subset of KEGG BRITE index (106KB)
│   │       │
│   │       │── # Extractor tab (hidden — code retained for future proxy re-enablement)
│   │       ├── AnalyzeView.swift         # Main extractor screen (PMID input, source choice, PDF upload, cache lookup)
│   │       ├── ExtractionCache.swift     # Offline extraction cache (JSON files in Application Support)
│   │       ├── PubMedService.swift       # PubMed esearch + efetch, PMCID conversion, PMC full text with section parser
│   │       ├── ClaudeService.swift       # Claude API integration (multi-taxon extraction)
│   │       ├── ExtractedPassport.swift   # Codable model for Claude output + demo data
│   │       ├── PassportResultView.swift  # Extracted passport display (+ MCA cross-reference + FlowLayout)
│   │       ├── PDFTextExtractor.swift    # PDF text extraction (25000 char cap)
│   │       ├── MailComposer.swift        # MFMailComposeViewController wrapper
│   │       ├── KeychainHelper.swift      # iOS Keychain save/load/delete
│   │       │
│   │       │── # About tab
│   │       ├── AboutView.swift           # Database stats, pipeline, acknowledgements
│   │       │
│   │       │── # Shared
│   │       ├── ColorExtension.swift      # Color(hex:) init + EvidenceColors (single source of truth for evidence grade colors)
│   │       └── MCA.sqlite                # Bundled database (read-only)
│   └── CLAUDE.md                         # This file
├── web/                        # Web application (PHP)
├── database/                   # XML snapshots, SQL dumps, xml2sql.py
├── staging/                    # Staging JSON files from mca-paper-curator
└── CLAUDE.md                   # Root project instructions
```

---

## Database schema

The bundled `MCA.sqlite` uses the same 10-table schema as the web version. `passport` is the central entity.

### Tables and verified column names

| Table | Key columns |
|-------|-----------|
| `passport` | id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed |
| `biology` | passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url |
| `taxon_tag` | id, passport_id, category, value, ext_id |
| `metabolite` | id, passport_id, **metabolite_name**, relationship, kegg_compound_id, chebi_id |
| `association` | id, passport_id, **association_text**, **evidence_level** |
| `assoc_pmid` | **association_id**, pmid |
| `assoc_ref` | id, **association_id**, ref_type, ref_id, ref_label |
| `passport_pmid` | passport_id, pmid |
| `paper` | pmid, title, authors, journal, year, study_design, population, sample_size |
| `meta` | key_name, key_value |

**Important column names** (past bugs from wrong names):
- `association.association_text` — NOT `content`
- `association.evidence_level` — NOT `evidence_grade`
- `metabolite.metabolite_name` — NOT `name`
- `assoc_pmid.association_id` / `assoc_ref.association_id` — NOT `assoc_id`

### taxon_tag categories

`synonym`, `key_trait`, `primary_niche`, `reservoir`, `transmission_route`, `role`, `typical_specimen`, `bloom_trigger`, `risk_context`, `amr_highlight`, `virulence_factor`

---

## Passport detail layout order

Follows the web's `passport.php` structure:

1. **Header** — preferred_name (large italic), lineage breadcrumbs (>), synonyms, ID block (passport_id, TaxID link, BacDive link, Rank)
2. **Biology** — Gram Status, Oxygen Tolerance, Morphology, Key Traits
3. **Ecology** — Primary Niches, Reservoirs, Transmission Routes
4. **Metabolites** — Grouped by relationship (produces/consumes/modifies) with KEGG/ChEBI badges
5. **Clinical Profile** — Pathobiont badges, Clinical Roles, Typical Specimens, Bloom Triggers, Risk Contexts, AMR Highlights, Virulence Factors, Clinical Associations, Last reviewed
6. **Evidence Timeline** — Horizontal scroll of paper cards (year + study design)
7. **Related Taxa** — 2-column grid with Niche/Risk match badges

---

## UI conventions

### Layout patterns

- **Section headers**: uppercase, `.caption.bold()`, color `#888888`, tracking 1.5, with Divider below
- **Data rows**: `InlineDataRow` — 130pt fixed-width label (`.caption.bold()`) + value (`.caption`, secondary color)
- **Association cards**: horizontal layout — 28x28 evidence badge on left, text + PMIDs on right, `#fafafa` background
- **Pathobiont**: 4 option badges (YES / NO / CONTEXT DEPENDENT / UNKNOWN) — active one highlighted, others dimmed
- **Evidence timeline**: horizontal `ScrollView` of 120pt-wide cards
- **Related taxa**: `LazyVGrid` 2-column with NavigationLink
- **Glossary**: accessible via `?` toolbar button on passport detail view

### External links

| Target | URL pattern |
|--------|-----------|
| NCBI Taxonomy | `https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id={ncbi_taxid}` |
| BacDive | Use `bacdive_url` from biology table (show only for species/subspecies/strain) |
| PubMed | `https://pubmed.ncbi.nlm.nih.gov/{pmid}/` |
| KEGG Compound | `https://www.genome.jp/entry/{kegg_compound_id}` |
| KEGG Drug | `https://www.kegg.jp/entry/{ext_id}` |
| KEGG Disease | `https://www.genome.jp/entry/{ref_id}` |
| ChEBI | `https://www.ebi.ac.uk/chebi/searchId.do?chebiId={chebi_id}` |
| MeSH | `https://meshb.nlm.nih.gov/record/ui?ui={ref_id}` |
| CARD (ARO) | `https://card.mcmaster.ca/ontology/{aro_number}` (strip `ARO:` prefix) |
| VFDB | `https://www.mgc.ac.cn/cgi-bin/VFs/vfs.cgi?VFID={ext_id}` |

---

## UI color system

All badge colors must match the web version. The canonical color reference is the root **CLAUDE.md** color tables. Do not introduce new semantic colors without updating this table.

`EvidenceColors.forGrade()` in `ColorExtension.swift` is the single source of truth for evidence grade colors — used by AboutView, PassportDetailView, and PassportResultView. GlossaryView hardcodes evidence colors in `evidenceGradeItem()` and must be kept in sync manually.

### Evidence grades

| Grade | Background | Text | Border | Visual |
|-------|-----------|------|--------|--------|
| E3 — Strong | `#dcfce7` | `#166534` | `#4ade80` | Green |
| E2 — Moderate | `#fef3c7` | `#92400e` | `#fbbf24` | Yellow |
| E1 — Limited | `#e5e7eb` | `#6b7280` | `#d1d5db` | Gray (slightly darker than web's `#f3f4f6`) |

### Pathobiont status

| Value | Background | Text | Border |
|-------|-----------|------|--------|
| `yes` (active) | `#007bff` | `#fff` | `#0056b3` |
| `context dependent` (active) | `#4b5563` | `#fff` | `#374151` |
| other active (`no`, `unknown`) | `#e5e7eb` | `#6b7280` | `#d1d5db` |
| inactive (dimmed) | `#f5f5f5` | `#cccccc` | `#eeeeee` |

### Ontology reference badges (Clinical Associations)

| Type | Background | Text | Border |
|------|-----------|------|--------|
| MeSH | `#d1fae5` | `#065f46` | `#6ee7b7` |
| KEGG Disease | `#ffedd5` | `#9a3412` | `#fdba74` |
| Other | `#f5f5f5` | `#555555` | `#dddddd` |

### Inline ext_id badges (Clinical Profile fields)

| Type | Background | Text | Border | Used on |
|------|-----------|------|--------|---------|
| ARO (CARD) | `#fee2e2` | `#991b1b` | `#fca5a5` | `amr_highlight` |
| KEGG Drug | `#ffedd5` | `#9a3412` | `#fdba74` | `bloom_trigger` |
| VFDB | `#fce7f3` | `#9d174d` | `#f9a8d4` | `virulence_factor` |

### Metabolite compound badges

| Type | Background | Text | Border |
|------|-----------|------|--------|
| KEGG Compound | `#ffedd5` | `#9a3412` | `#fdba74` |
| ChEBI | `#e0f2fe` | `#0369a1` | `#7dd3fc` |

### Related taxa match tags

| Tag | Background | Text | Border |
|-----|-----------|------|--------|
| Niche | `#efefef` | `#555555` | `#d8d8d8` |
| Risk | `#f0ece8` | `#7a6a5f` | `#ddd0c8` |

### Brand / structural colors

| Use | Value |
|-----|-------|
| Primary brand / accent | `#404f7c` |
| Timeline year text | `#404f7c` |
| PubMed links | `#007bff` |
| Section title / muted text | `#888888` |
| Association card background | `#fafafa` |
| Related taxon card background | `#f5f6fa` |
| Related taxon card border | `#e0e2ee` |

---

## Key constants

| Constant | Value |
|----------|-------|
| Developer email | `bioinformatics@ucalgary.ca` |
| Claude model | `claude-opus-4-6` |
| Claude endpoint | `https://api.anthropic.com/v1/messages` |
| Anthropic version header | `2023-06-01` |
| Max Claude tokens | 8192 |
| Max text cap (PMC & PDF) | 25000 characters |
| Keychain service | `com.mca.analyzer` |
| Keychain account | `claudeApiKey` |

---

## Extraction cache

- Extractions are cached as JSON files in `Application Support/ExtractionCache/{uuid}.json`
- Managed by `ExtractionCache` static helper (save/loadAll/find/delete)
- Demo extractions are NOT cached (guarded by `isDemo` flag)
- Empty extractions (no taxa found) are NOT cached
- When user enters a PMID that's already cached, an alert offers: View Cached / Extract Again / Cancel
- Recent extractions appear in the Extractor idle state with swipe-to-delete

---

## Architecture notes

- `DatabaseManager.mapPassport()` is the single helper for passport row mapping (avoids duplication)
- `fetchAssociations()` uses batch IN-clause queries (3 queries total, not N+2)
- `EvidenceColors.forGrade()` centralizes evidence grade colors — used by 3 views
- PassportDetailView toolbar: ShareLink (passport name + ID) + Glossary button

---

## App Store

- **App Store URL:** https://apps.apple.com/app/microbial-clinical-atlas/id6761735200
- **App ID:** 6761735200
- **Bundle ID:** `ca.thebiohub.mca`
- **First approved:** 2026-04-09
- **Free app, no in-app purchases**

### Submitting updates

1. Bump `MARKETING_VERSION` (e.g., `1.0.0` → `1.1.0`) and `CURRENT_PROJECT_VERSION` (build number) in `project.pbxproj`
2. In Xcode: Product → Archive (destination: Any iOS Device arm64)
3. Organizer → Distribute App → App Store Connect → Upload
4. In App Store Connect: create new version, select the build, update "What's New", submit for review

### Screenshots

At minimum: Passports list, Passport detail, Search tab, About tab

---

## What NOT to do

- Do not add external Swift packages — Apple frameworks only
- Do not edit `project.pbxproj` beyond version bumps — other changes via Xcode UI only
- Do not use WAL journal mode for SQLite — app bundle is read-only
- Do not link to ontologies from the Extractor output — pure text extraction
- Do not introduce new badge colors without updating the color table above
