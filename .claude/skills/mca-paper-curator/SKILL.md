---
name: mca-paper-curator
description: "MCA curation skill for extracting clinically meaningful microbial entities and relationships from a research paper (PDF) and writing a structured staging file for human review. Covers paper analysis, entity extraction, CREATE/UPDATE routing against the existing XML, and evidence grading via a dedicated subagent. Triggers on: curate paper, add paper to MCA, extract from paper, curate taxon, update passport."
metadata:
  version: "3.6"
  last_updated: "2026-04-02"
---

# MCA Paper Curator v3.6 — Microbiome Knowledge Base Curation Skill

Reads one or more research papers (PDFs) and writes structured staging files per taxon. Biology and ecology fields are populated from NCBI Taxonomy and BacDive by TaxID — not from the PDF. The paper is the source only for the clinical layer: pathobiont status, clinical roles, bloom triggers, AMR, metabolites, and clinical associations.

---

## Quick Start

**Single paper:**
```
Curate this paper: [attach PDF — filename must be the PMID, e.g. 38123456.pdf]
```

**Multiple papers (parallel):**
```
Curate these papers: [attach PDF1, PDF2, PDF3 — each filename must be its PMID]
```

**Input convention:** Each PDF filename (without extension) is the PMID. Before any analysis begins, the skill validates every filename. If any filename is not a valid PMID, the skill halts and asks the user to rename that file before proceeding. When multiple PDFs are provided, each paper runs its own complete pipeline (Phases 0–4) in parallel as an independent agent. Staging files are written per taxon per paper; all results are reported together at the end.

**Output:**
1. Paper metadata summary (PMID from filename, title, study design, population)
2. Identified taxa and extracted MCA entity fields
3. CREATE / UPDATE routing decision per taxon
4. Evidence grade (E1 / E2 / E3 / UNCERTAIN) with written rationale
5. Staging file written to `staging/YYYY-MM-DD_[taxon-name].json`
6. QC report written to `staging/YYYY-MM-DD_[taxon-name]-qc-report.md`

---

## Trigger Conditions

**Trigger keywords:** curate paper, add paper to MCA, extract from paper, curate taxon, update passport, add to knowledge base

**Non-trigger scenarios:**

| Scenario | What to do instead |
|----------|--------------------|
| Applying an approved staging file to the XML | Use the MCA XML Update Skill (Skill 2, not yet written) |
| General literature search (no curation intent) | Standard research query |
| Editing an existing passport manually | Edit the XML directly |

---

## Agent Team (12 Agents)

| # | Agent | Role | Phase |
|---|-------|------|-------|
| 1 | `paper_analyst_agent` | Reads the PDF; extracts paper metadata (PMID, title, abstract, authors, journal, year, study design, population, sample size) and identifies all taxa mentioned. **Spawned with claude-opus-4-6** — taxon identification and abstract extraction are scope-setting for all downstream agents. | Phase 0 |
| 2 | `db_fetch_agent` | Given TaxID, queries NCBI Taxonomy (lineage, synonyms) and BacDive (biology, ecology); populates all fields available from structured databases | Phase 1 |
| 3 | `entity_extractor_agent` | Extracts the clinical layer from the paper: pathobiont status, clinical roles, typical specimens, bloom triggers, risk contexts, AMR highlights, virulence factors, metabolites, and clinical associations | Phase 1 |
| 4 | `routing_agent` | Checks each taxon against the current XML; determines CREATE or UPDATE; identifies `passport_id` for updates | Phase 1 |
| 5 | `grading_agent` | Assigns a single evidence grade (E1 / E2 / E3) for the whole paper with written rationale; assigns `UNCERTAIN` (with `uncertain_reason`) when study design is ambiguous or unreported — staging file is still written | Phase 1 |
| 6 | `mesh_agent` | Fetches paper MeSH annotations from NLM E-utilities API; assigns relevant MeSH terms per clinical association; resolves MeSH anatomy IDs for body sites and specimen types | Phase 2 |
| 7 | `kegg_agent` | Maps clinical conditions → KEGG Disease IDs; bloom trigger drugs → KEGG Drug IDs; metabolite names → KEGG Compound IDs — all via local KEGG flat file mirror | Phase 2 |
| 8 | `aro_agent` | Maps AMR phenotype names to CARD ARO identifiers via local ARO JSON index (OBO Foundry source) | Phase 2 |
| 9 | `vfdb_agent` | Maps virulence factor names to VFDB VFIDs via local VFDB JSON mirror (`vfdb.json`) | Phase 2 |
| 10 | `null_review_agent` | Re-attempts all null ext_id fields using alternative strategies and local index / web fallbacks; classifies each null as `confirmed_null`, `filled`, or `needs_review` before the staging file is written | Phase 3 |
| 11 | `sanity_check_agent` | Validates all fields (null and non-null) for format correctness, controlled vocabulary compliance, and logical consistency (Checks 1–5). **Spawned with claude-haiku-4-5.** | Phase 4 |
| 12 | `qc_report_agent` | Aggregates null-field root causes from the `null_review` block, detects pipeline improvement patterns, appends `missing_value_report` to the `sanity_check` block, and writes the human-readable QC Markdown report. **Spawned with claude-haiku-4-5.** | Phase 4 |

---

## Orchestration Workflow (5 Phases)

```
User: "Curate these papers" + [one or more PDFs — each filename is its PMID]
     |
=== Pre-Phase: FILENAME VALIDATION (all PDFs, before any pipeline starts) ===
     |
     +-> For each PDF, extract filename stem (strip .pdf extension)
         - Check: stem is digits only AND 1–8 characters long
         - ALL pass → proceed to duplicate check for each PDF
         - ANY fail → HALT immediately; list all invalid filenames and inform the user:
                  "The filename '[stem]' is not a valid PMID.
                   Please rename the file to its PubMed ID (digits only, e.g. 38123456.pdf)
                   and try again."
     |
=== Pre-Phase: DUPLICATE PMID CHECK ===
     |
     +-> Read `database/curation_log.json`
         - Scan every entry for `source_pmid` matching the validated PMID
           (compare as integer; the log stores source_pmid as a JSON number)
         - If NO matches found → proceed to Phase 0 immediately (no message needed)
         - If matches found → HALT and warn the user:

           "⚠️  PMID [pmid] has already been curated.
            The following passports were previously applied from this paper:

            | passport_id       | preferred_name         | action | date_applied |
            |-------------------|------------------------|--------|--------------|
            | MCA-BAC-000001    | Clostridioides difficile | CREATE | 2026-04-01  |
            | ...               | ...                    | ...    | ...          |

            Do you want to:
              (a) Proceed anyway — useful if you are adding new taxa not yet curated from this paper
              (b) Abort — the paper has already been fully curated

            Reply 'proceed' or 'abort'."

         - User replies 'abort' → HALT; do not proceed
         - User replies 'proceed' (any case) → continue to Phase 0;
           add `duplicate_pmid_warning: true` to the paper_summary block of every
           staging file produced in this session so the reviewer is aware
         - If `database/curation_log.json` does not exist → treat as no matches; proceed to Phase 0
     |
=== PARALLEL LAUNCH (multi-PDF only) ===
     |
     +-> When multiple PDFs are provided, spawn one independent pipeline per PDF
         (Phases 0–4) as parallel agents. Each pipeline is fully self-contained:
         its own paper_analyst, db_fetch, entity_extractor, routing, grading,
         mesh/kegg/aro/vfdb enrichment, null_review, sanity_check, and qc_report
         agents run independently for that paper.
         - NLM API calls (Phase 2 pre-fetch) are made per pipeline — one efetch call
           per PMID, no sharing between pipelines.
         - Staging files written by each pipeline are independent; filename collisions
           only occur if two papers produce the same taxon as a new CREATE — the
           routing_agent guard (see ROUTING_AGENT.md) handles this via AMBIGUOUS routing.
         - All pipeline results are collected and reported together in a single
           summary message to the user at the end.
     |
=== Phase 0: PAPER ANALYSIS ===
     |
     +-> [paper_analyst_agent]
         - Reads the full PDF
         - PMID is taken from the filename (already validated); do not search for it in the PDF
         - Extracts: title, authors, journal, year
         - Identifies: study design, study population, sample size
         - Lists all taxa mentioned in the paper (preferred names + any synonyms used)
         - Cross-checks XML passport names against the paper's main text; returns
           cross_check_flags[] for any XML passport name found in the paper but
           absent from the confirmed taxa list (potential Phase 0 omissions)
         - Writes paper summary into staging file (no user confirmation required)
     |
=== Phase 1: DB FETCH, ENTITY EXTRACTION, ROUTING & GRADING (parallel) ===
     |
     |-> [db_fetch_agent] (parallel — one per taxon)
     |   Per taxon identified in Phase 0:
     |   - Queries NCBI Taxonomy by TaxID → lineage, rank, domain, synonyms
     |   - Queries BacDive by TaxID → gram status, oxygen tolerance, morphology,
     |     key traits, primary niches (with mesh_anatomy_id: null), reservoirs
     |   - Maps all fetched values to controlled vocabulary
     |   - Best-effort: failures logged in db_fetch_notes, do not block
     |
     |-> [entity_extractor_agent] (parallel — one per taxon)
     |   Per taxon identified in Phase 0 — paper only, clinical layer only:
     |   - Clinical profile: pathobiont status, clinical roles,
     |                        typical specimens (with mesh_anatomy_id: null),
     |                        bloom triggers (with kegg_drug_id: null),
     |                        risk contexts, AMR highlights (with aro_id: null)
     |   - Transmission routes: only if paper explicitly reports them in Results/Discussion
     |   - Metabolites: name, relationship (with kegg_compound_id: null, chebi_id: null)
     |   - Clinical associations: claim text, evidence_type,
     |                             assoc_refs: [] (populated in Phase 2)
     |   - Do NOT extract biology or ecology fields — those come from db_fetch_agent
     |   - Only extract what the paper explicitly reports; leave unknown fields null
     |
     |-> [routing_agent] (parallel)
     |   - Searches the most recent database/MCA_DB_*.xml by preferred_name,
     |     synonym, and ncbi_taxid
     |   - Decision per taxon:
     |       CREATE — taxon not found in XML; full new passport required
     |       UPDATE — taxon found; identify passport_id; diff proposed changes
     |
     +-> [grading_agent] (parallel)
         - Receives: abstract, title, journal, year, study_design, population, sample_size from Phase 0
         - Does NOT receive pmid — not needed for grading
         - Assigns ONE grade for the entire paper
         - Grades: E3 (strong clinical) / E2 (moderate) / E1 (limited/preliminary)
         - Writes rationale (2–3 sentences); uses abstract to resolve ambiguous study_design
         - Flags UNCERTAIN if study design is ambiguous or not reported
     |
=== Phase 1 → Phase 2 MERGE ===
     |
     +-> Match all Phase 1 outputs by preferred_name. Per taxon, produce a single merged object:
           action, passport_id, matched_on       ← from routing_agent
           identity, biology, ecology            ← from db_fetch_agent
           clinical_profile, metabolites,
           clinical_associations                 ← from entity_extractor_agent
           transmission_routes                   ← entity_extractor_agent (if reported);
                                                    otherwise [] from db_fetch_agent
           extraction_notes                      ← union of db_fetch_notes +
                                                    entity_extractor notes +
                                                    routing_notes
         Process cross_check_flags[] from Phase 0: fold into extraction_notes per
         ROUTING_AGENT.md rules (orphaned flags → staging/YYYY-MM-DD_cross-check-flags.json).
         This merged object is passed to Phase 2 agents and used to assemble the staging file.
     |
=== Phase 2 PRE-FETCH: NLM API CALLS (orchestrator — before spawning any Phase 2 agents) ===
     |
     +-> The orchestrator makes all NLM network calls directly (not via subagents):
         1. Fetch paper MeSH annotations:
            WebFetch → https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id={pmid}&retmode=xml
            Store raw XML as `nlm_efetch_xml`
            If this call fails (technical error): HALT — interrupt user before proceeding
         2. Resolve anatomy IDs for all unique body site / specimen terms from Phase 1 merge:
            For each unique CV term in primary_niches[] + typical_specimens[]:
              WebFetch → https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5
              Extract best anatomy match; store as {cv_term → mesh_anatomy_id} in `anatomy_lookup_results`
              No match → store null for that term (not a failure)
            Respect NLM rate limit: max 3 requests/second
         Pass `nlm_efetch_xml` and `anatomy_lookup_results` as explicit inputs to mesh_agent.
     |
=== Phase 2: ONTOLOGY ENRICHMENT (parallel — requires Phase 1 merged output + NLM pre-fetch) ===
     |
     |-> [mesh_agent] (see agents/MESH_AGENT.md)
     |   - Receives pre-fetched `nlm_efetch_xml` and `anatomy_lookup_results` from orchestrator
     |   - Filters and assigns relevant MeSH terms to each clinical association
     |     → populates assoc_refs[ref_type=mesh] on each association
     |   - Applies pre-resolved anatomy IDs to primary_niches and
     |     typical_specimens → populates mesh_anatomy_id
     |   - Makes no network calls itself
     |
     |-> [kegg_agent] (see agents/KEGG_AGENT.md)
     |   - Reads local KEGG flat file mirror
     |   - Maps clinical association conditions → KEGG Disease IDs (H numbers)
     |     → populates assoc_refs[ref_type=kegg_disease] on each association
     |   - Maps bloom trigger drug names → KEGG Drug IDs (D numbers)
     |     → populates kegg_drug_id on bloom_trigger objects
     |   - Maps metabolite names → KEGG Compound IDs (C numbers)
     |     → populates kegg_compound_id on metabolite objects
     |
     |-> [aro_agent] (see agents/ARO_AGENT.md)
     |   - Reads local ARO JSON index; falls back to OBO Foundry file if index is missing
     |   - Maps AMR phenotype names → ARO identifiers
     |     → populates aro_id on amr_highlight objects
     |
     +-> [vfdb_agent] (see agents/VFDB_AGENT.md)
         - Reads local VFDB JSON mirror (no network calls)
         - Maps virulence factor names → VFDB VFIDs
           → populates vfdb_id on virulence_factor objects
     |
=== Phase 3: STAGING FILE OUTPUT + NULL REVIEW ===
     |
     +-> Step 1 — Merge Phase 2 enrichment into the Phase 1 merged object:
         - Phase 2 enrichment merged into the relevant fields of the Phase 1 object:
             assoc_refs, mesh_anatomy_id, kegg_drug_id, kegg_compound_id, aro_id, vfdb_id
         - Enrichment notes (mesh_notes, kegg_notes, aro_notes, vfdb_notes) folded into
           extraction_notes[]
     |
     +-> Step 2 — [null_review_agent] (see agents/NULL_REVIEW_AGENT.md)
         Runs on the merged object before the staging file is written:
         - For every null ext_id field, attempts re-lookup with alternative strategies
           using local indexes first (ARO, ChEBI, NCBI), then web fallbacks (KEGG flat files, NLM API, ChEBI REST, NCBI Esearch)
         - Classifies each null as:
             confirmed_null — sentinel value, known-null class, or no match after re-attempt
             filled         — match found; field updated in staging object
             needs_review   — candidate found but confidence insufficient to auto-fill
         - Appends `null_review` block to staging object; applies `filled` values in-place
     |
     +-> Step 3 — Write staging JSON per taxon:
         - One file per taxon: staging/YYYY-MM-DD_[taxon-name].json
         - Schema follows templates/STAGING_FILE.md
         - Includes `null_review` block from Step 2
     |
=== Phase 4: SANITY CHECK ===
     |
     +-> Pre-check: db_access_failure retry (orchestrator)
         Before spawning sanity_check_agent, scan null_review findings for any entry tagged
         `db_access_failure` (technical failure, not a data gap). For each such entry, the
         orchestrator may retry the affected Phase 2 or null_review lookup once. If the retry
         succeeds, update the staging file before passing to sanity_check_agent. This is the
         only retry mechanism in the pipeline.
     |
     +-> [sanity_check_agent] (see agents/SANITY_CHECK_AGENT.md)
         **Spawned with claude-haiku-4-5 for speed. Annotation only — no agent retries.**
         Checks 1–5 only — reads each written staging file and:
         - Check 1 — Format: all non-null ext_ids match expected patterns (ARO:, D#####, etc.)
         - Check 2 — Controlled vocabulary: closed fields contain only allowed values
         - Check 3 — Logical consistency: pathobiont/role contradictions, grade/study-design mismatches
         - Check 4 — Required fields: preferred_name, domain, action, association PMIDs, etc.
         - Check 5 — Structural completeness: empty association lists, duplicate claims
         Writes one output per taxon:
           `sanity_check` block (status + errors + warnings) appended to staging JSON
     |
     +-> [qc_report_agent] (see agents/QC_REPORT_AGENT.md)
         **Spawned with claude-haiku-4-5 for speed. Runs after sanity_check_agent.**
         Reads `null_review` block and `sanity_check` block from each staging file and:
         - Aggregates all null-field root causes into 7 categories
           (sentinel, known_null_class, no_match_in_db, pipeline_miss, etc.)
         - Raises pattern flags when ≥2 nulls share the same root cause + field type
         Writes two outputs per taxon:
           1. `missing_value_report` appended to `sanity_check` block in staging JSON
           2. `staging/YYYY-MM-DD_[taxon]-qc-report.md` — human-readable Markdown report
              with validation issues, missing value analysis, and pipeline miss log
     |
     ** Inform user of staging file path(s), QC report path(s), and overall status
        (PASS/WARN/FAIL per taxon); errors listed inline if status is FAIL.
        For multi-PDF runs: group results by paper (PMID) in the summary.
        No XML is modified at this step. **
```

---

## Checkpoint Rules

0. **Pre-phase — filename validation**: If the filename stem is not digits-only (1–8 chars), halt immediately and ask the user to rename the file; do not proceed
0b. **Pre-phase — duplicate PMID check**: After filename validation, read `database/curation_log.json` and check whether the PMID appears as any `source_pmid`. If it does, HALT and show the user a table of previously applied passports; wait for an explicit 'proceed' or 'abort' reply before continuing. If the log file does not exist, proceed without a warning.
1. **No mid-skill stops**: The skill runs end-to-end (Phase 0 → Phase 4) without pausing for user confirmation at any phase boundary (except the duplicate PMID gate in checkpoint 0b). The user reviews everything in the final staging file.
2. **Phase 0 — paper summary**: Written directly into the staging file; no user confirmation required; PMID is always taken from the filename, not the PDF text
3. **Phase 1 — extraction boundary**: Only extract what the paper explicitly states; do not infer or embellish beyond reported findings
4. **Phase 1 — UPDATE diff**: For UPDATE actions, only propose fields that differ from what is already in the XML; do not overwrite unchanged fields
5. **Phase 1 — one grade per paper**: A single evidence grade applies to the whole paper and all associations extracted from it
6. **Phase 1 — uncertainty flag**: If study design cannot be determined, `grading_agent` must flag `UNCERTAIN` rather than guess; the staging file is still written with `UNCERTAIN` flagged for human review
7. **Phase 2 — enrichment failure handling**: Distinguish two failure types:
   - **Technical blocker** (tool permission denied, required file inaccessible, network timeout, archive cannot be opened): **HALT immediately** and interrupt the user with a clear message explaining which tool was blocked and what is needed to proceed. Do not write staging files. Do not silently continue.
   - **Data gap** (term not found in ontology, API returns empty results, no matching KEGG entry): continue without blocking; log in `extraction_notes`; affected fields remain `null`.

   > **Rationale:** A permission denial means the enrichment step did not run at all — the user cannot meaningfully review a staging file that is missing IDs due to a tool misconfiguration. A missing ontology match is expected and reviewable.
8. **Phase 3 — null_review is non-blocking**: Lookup failures in `null_review_agent` go into the `null_review` block and do not halt the skill. The staging file is always written.
9. **Phase 4 — non-blocking**: Neither `sanity_check_agent` nor `qc_report_agent` halts the skill. A `FAIL` status in `sanity_check_agent` is written to the staging file as an annotation; `qc_report_agent` always writes its `.md` report regardless of status. The user sees all findings in the final message and decides whether to fix before applying.
10. **Phase 3/4 — no XML writes**: This skill ends at writing the staging file; the XML is never touched here

---

## CREATE vs UPDATE Rules

| Scenario | Action | Behaviour |
|----------|--------|-----------|
| Taxon not in XML (by name, synonym, or TaxID) | CREATE | Fill all extractable fields from paper; leave unknown fields blank or `null` |
| Taxon found in XML | UPDATE | Propose additions to existing fields and new clinical associations; do not remove or overwrite existing data without explicit user instruction |
| Taxon found under a synonym | UPDATE | Match to existing passport; note the synonym used in the paper |
| Taxon is ambiguous (e.g., genus-level vs species-level) | `AMBIGUOUS` | Staging file written with `action: AMBIGUOUS` and ambiguity described in `extraction_notes`; no halt — user resolves when reviewing the staging file |

---

## Staging File Output

One JSON file per taxon, written to `staging/`. Schema defined in `templates/STAGING_FILE.md`.

**Filename format:** `staging/YYYY-MM-DD_[taxon-name-kebab-case].json`

**Example:** `staging/2026-03-31_clostridioides-difficile.json`

---

## Agent File References

| Agent | Definition File |
|-------|----------------|
| `paper_analyst_agent` | `agents/PAPER_ANALYST_AGENT.md` |
| `db_fetch_agent` | `agents/DB_FETCH_AGENT.md` |
| `entity_extractor_agent` | `agents/ENTITY_EXTRACTOR_AGENT.md` |
| `routing_agent` | `agents/ROUTING_AGENT.md` |
| `grading_agent` | `agents/GRADING_AGENT.md` |
| `mesh_agent` | `agents/MESH_AGENT.md` |
| `kegg_agent` | `agents/KEGG_AGENT.md` |
| `aro_agent` | `agents/ARO_AGENT.md` |
| `vfdb_agent` | `agents/VFDB_AGENT.md` |
| `null_review_agent` | `agents/NULL_REVIEW_AGENT.md` |
| `sanity_check_agent` | `agents/SANITY_CHECK_AGENT.md` |
| `qc_report_agent` | `agents/QC_REPORT_AGENT.md` |

---

## Reference Files

| Reference | Purpose | Used By |
|-----------|---------|---------|
| `references/GRADING_CRITERIA.md` | Evidence grading rules and study design classification | `grading_agent` |
| `references/CONTROLLED_VOCABULARY.md` | Allowed values for controlled fields (gram status, roles, niches, etc.) | `entity_extractor_agent` |

---

## Templates

| Template | Purpose |
|----------|---------|
| `templates/TAXON_PASSPORT.md` | Blank passport field template used during extraction |
| `templates/STAGING_FILE.md` | Staging JSON schema — defines the handoff format between this skill and the XML update skill |

---

## Examples

| Example | Demonstrates |
|---------|-------------|
| `examples/TAXON_PASSPORT_EXAMPLE.md` | Filled passport example showing expected field values and formatting |

---

## Quality Standards

| Dimension | Requirement |
|-----------|-------------|
| Extraction fidelity | Only extract what the paper explicitly reports; no inference beyond stated findings |
| Controlled vocabulary | All extracted field values must match terms defined in `references/CONTROLLED_VOCABULARY.md` |
| Evidence traceability | Every clinical association must include the source PMID |
| Grading consistency | One grade per paper; rationale must cite specific study design features |
| UPDATE integrity | UPDATE proposals must not remove or overwrite existing passport data |
| Uncertainty handling | Ambiguous study designs and unresolvable taxa must be flagged, not silently resolved |
| Staging completeness | Staging file must be valid against `templates/STAGING_FILE.md` schema before being written |
| Null review | Every null ext_id must be classified (`confirmed_null` / `filled` / `needs_review`) before the staging file is finalised |
| Sanity check | Every staging file must have a `sanity_check` block (PASS / WARN / FAIL + errors/warnings from `sanity_check_agent`) and a `missing_value_report` block (root-cause analysis from `qc_report_agent`) before being presented to the human reviewer |

---

## Integration

```
[User provides PDF(s)]
        |
   SKILL.md — pre-phase validation + duplicate check (all PDFs)
        |
   ┌────────────────┬────────────────┬──────────────────┐
   │  Pipeline: PDF1│  Pipeline: PDF2│  Pipeline: PDF3  │  (parallel)
   │  Phases 0–4   │  Phases 0–4   │  Phases 0–4      │
   └────────────────┴────────────────┴──────────────────┘
        |
   staging/YYYY-MM-DD_[taxon].json (one per taxon per paper)
        |   <-- human reviews staging files
   MCA XML Update Skill (mca-xml-update)
        |
   database/MCA_DB_vX.X.xml (updated)
```

---

## Version Info

| Item | Content |
|------|---------|
| Skill Version | 3.6 |
| Last Updated | 2026-04-02 |
| Maintainer | Heewon Seo |
| Input | One or more research papers (PDFs); each filename stem must be the PMID (digits only, e.g. `38123456.pdf`) |
| Output | `staging/YYYY-MM-DD_[taxon-name].json` |
| Downstream Skill | MCA XML Update Skill (`mca-xml-update`) |

---

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md) for the full version history.
