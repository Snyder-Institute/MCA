---
name: mca-paper-curator
description: "MCA curation skill for extracting clinically meaningful microbial entities and relationships from a research paper (PDF) and writing a structured staging file for human review. Covers paper analysis, entity extraction, CREATE/UPDATE routing against the existing XML, and evidence grading via a dedicated subagent. Triggers on: curate paper, add paper to MCA, extract from paper, curate taxon, update passport."
metadata:
  version: "2.3"
  last_updated: "2026-04-01"
---

# MCA Paper Curator v2.3 — Microbiome Knowledge Base Curation Skill

Reads a research paper (PDF), extracts taxa and clinically meaningful features, maps them to the MCA entity model, determines whether each taxon requires a new Taxon Passport (CREATE) or an update to an existing one (UPDATE), grades the evidence via a dedicated grading subagent, and writes a structured staging file for human review before any changes are applied to the database.

---

## Quick Start

```
Curate this paper: [attach PDF — filename must be the PMID, e.g. 38123456.pdf]
```

**Input convention:** The PDF filename (without extension) is the PMID. Before any analysis begins, the skill validates that the filename is a valid PMID (digits only, 1–8 characters). If the filename is not a valid PMID, the skill halts and asks the user to rename the file.

**Output:**
1. Paper metadata summary (PMID from filename, title, study design, population)
2. Identified taxa and extracted MCA entity fields
3. CREATE / UPDATE routing decision per taxon
4. Evidence grade (E1 / E2 / E3 / UNCERTAIN) with written rationale
5. Staging file written to `staging/YYYY-MM-DD_[taxon-name].json`

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

## Agent Team (7 Agents)

| # | Agent | Role | Phase |
|---|-------|------|-------|
| 1 | `paper_analyst_agent` | Reads the PDF; extracts paper metadata (PMID, title, authors, journal, year, study design, population, sample size) and identifies all taxa mentioned | Phase 0 |
| 2 | `entity_extractor_agent` | Maps paper findings to MCA entity model fields (biology, ecology, clinical profile, metabolites, clinical associations) per taxon | Phase 1 |
| 3 | `routing_agent` | Checks each taxon against the current XML; determines CREATE (new passport) or UPDATE (existing passport); identifies `passport_id` for updates | Phase 1 |
| 4 | `grading_agent` | Assigns a single evidence grade (E1 / E2 / E3) for the whole paper with written rationale; flags uncertainty when study design is ambiguous or unreported | Phase 1 |
| 5 | `mesh_agent` | Fetches paper MeSH annotations from NLM E-utilities API; filters relevant terms per clinical association; resolves MeSH anatomy IDs for body sites and specimen types | Phase 2 |
| 6 | `kegg_agent` | Maps clinical conditions → KEGG Disease IDs; bloom trigger drugs → KEGG Drug IDs; metabolite names → KEGG Compound IDs — all via local KEGG flat file mirror | Phase 2 |
| 7 | `aro_agent` | Maps AMR phenotype names to CARD ARO identifiers via local CARD ontology data or CARD web API | Phase 2 |

---

## Orchestration Workflow (4 Phases)

```
User: "Curate this paper" + [PDF — filename is PMID, e.g. 38123456.pdf]
     |
=== Pre-Phase: FILENAME VALIDATION ===
     |
     +-> Extract filename stem (strip .pdf extension)
         - Check: stem is digits only AND 1–8 characters long
         - PASS → use stem as the PMID for the entire session; proceed to Phase 0
         - FAIL → HALT immediately; inform the user:
                  "The filename '[stem]' is not a valid PMID.
                   Please rename the file to its PubMed ID (digits only, e.g. 38123456.pdf)
                   and try again."
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
=== Phase 1: ENTITY EXTRACTION, ROUTING & GRADING (parallel) ===
     |
     |-> [entity_extractor_agent]
     |   Per taxon identified in Phase 0:
     |   - Biology: gram status, oxygen tolerance, morphology, key traits
     |   - Ecology: primary niches (with mesh_anatomy_id: null), reservoirs,
     |              transmission routes
     |   - Clinical profile: pathobiont status, clinical roles,
     |                        typical specimens (with mesh_anatomy_id: null),
     |                        bloom triggers (with kegg_drug_id: null),
     |                        risk contexts, AMR highlights (with aro_id: null)
     |   - Metabolites: name, relationship (with kegg_compound_id: null, chebi_id: null)
     |   - Clinical associations: claim text, evidence_type,
     |                             assoc_refs: [] (populated in Phase 2)
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
         - Receives: paper metadata + study design from Phase 0
         - Assigns ONE grade for the entire paper
         - Grades: E3 (strong clinical) / E2 (moderate) / E1 (limited/preliminary)
         - Writes rationale (2–3 sentences)
         - Flags UNCERTAIN if study design is ambiguous or not reported
     |
=== Phase 1 → Phase 2 MERGE ===
     |
     +-> Match entity_extractor_agent and routing_agent outputs by preferred_name.
         Per taxon, produce a single merged object:
           action, passport_id, matched_on  ← from routing_agent
           proposed_changes, extraction_notes ← from entity_extractor_agent
           append routing_notes[] → extraction_notes[]
         Process cross_check_flags[] received from Phase 0 output: fold each flag into
         extraction_notes of the most closely related taxon staging file per the rules in
         ROUTING_AGENT.md (orphaned flags → staging/YYYY-MM-DD_cross-check-flags.json).
         This merged object is passed to Phase 2 agents and used to assemble the staging file.
     |
=== Phase 2: ONTOLOGY ENRICHMENT (parallel — requires Phase 1 merged output) ===
     |
     |-> [mesh_agent] (see agents/MESH_AGENT.md)
     |   - Fetches paper MeSH annotations from NLM E-utilities API via PMID
     |   - Filters and assigns relevant MeSH terms to each clinical association
     |     → populates assoc_refs[ref_type=mesh] on each association
     |   - Resolves MeSH anatomy IDs for extracted primary_niches and
     |     typical_specimens → populates mesh_anatomy_id
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
     +-> [aro_agent] (see agents/ARO_AGENT.md)
         - Reads local CARD ontology data (or uses CARD web API as fallback)
         - Maps AMR phenotype names → ARO identifiers
           → populates aro_id on amr_highlight objects
     |
=== Phase 3: STAGING FILE OUTPUT ===
     |
     +-> Merge Phase 2 enrichment into the Phase 1 merged object; write staging JSON per taxon
         - One file per taxon: staging/YYYY-MM-DD_[taxon-name].json
         - Schema follows templates/STAGING_FILE.md
         - Phase 2 enrichment is merged into the relevant fields of the Phase 1 object:
             assoc_refs, mesh_anatomy_id, kegg_drug_id, kegg_compound_id, aro_id
         - Enrichment notes (mesh_notes, kegg_notes, aro_notes) folded into
           extraction_notes[]
     |
     ** Inform user of staging file path(s); no XML is modified at this step **
```

---

## Checkpoint Rules

0. **Pre-phase — filename validation**: If the filename stem is not digits-only (1–8 chars), halt immediately and ask the user to rename the file; do not proceed
1. **No mid-skill stops**: The skill runs end-to-end (Phase 0 → Phase 3) without pausing for user confirmation at any phase boundary. The user reviews everything in the final staging file.
2. **Phase 0 — paper summary**: Written directly into the staging file; no user confirmation required; PMID is always taken from the filename, not the PDF text
3. **Phase 1 — extraction boundary**: Only extract what the paper explicitly states; do not infer or embellish beyond reported findings
4. **Phase 1 — UPDATE diff**: For UPDATE actions, only propose fields that differ from what is already in the XML; do not overwrite unchanged fields
5. **Phase 1 — one grade per paper**: A single evidence grade applies to the whole paper and all associations extracted from it
6. **Phase 1 — uncertainty flag**: If study design cannot be determined, `grading_agent` must flag `UNCERTAIN` rather than guess; the staging file is still written with `UNCERTAIN` flagged for human review
7. **Phase 2 — enrichment is best-effort**: Ontology ID lookup failures (NLM API down, KEGG file not found, CARD unavailable) do not block staging file output. Failed lookups are logged in `extraction_notes`; affected fields remain `null`.
8. **Phase 3 — no XML writes**: This skill ends at writing the staging file; the XML is never touched here

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
| `entity_extractor_agent` | `agents/ENTITY_EXTRACTOR_AGENT.md` |
| `routing_agent` | `agents/ROUTING_AGENT.md` |
| `grading_agent` | `agents/GRADING_AGENT.md` |
| `mesh_agent` | `agents/MESH_AGENT.md` |
| `kegg_agent` | `agents/KEGG_AGENT.md` |
| `aro_agent` | `agents/ARO_AGENT.md` |

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

---

## Integration

```
[User provides PDF]
        |
   SKILL.md (this skill) — Phases 0-3
        |
   staging/YYYY-MM-DD_[taxon].json   <-- human reviews this file
        |
   MCA XML Update Skill (Skill 2, not yet written)
        |
   database/MCA_DB_vX.X.xml (updated)
```

---

## Version Info

| Item | Content |
|------|---------|
| Skill Version | 2.3 |
| Last Updated | 2026-04-01 |
| Maintainer | Heewon Seo |
| Input | Research paper (PDF); filename stem must be the PMID (digits only, e.g. `38123456.pdf`) |
| Output | `staging/YYYY-MM-DD_[taxon-name].json` |
| Downstream Skill | MCA XML Update Skill (`mca-xml-update`) |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.3 | 2026-04-01 | **Second integrity pass (9 fixes):** Cross-check scanning moved to paper_analyst_agent; routing_agent now receives and processes cross_check_flags[] from Phase 0 only. Length-preservation rule added to mesh_agent and kegg_agent. MESH_AGENT.md: CONTROLLED_VOCABULARY.md added to inputs. ARO_AGENT.md: removed misleading project-memory reference for CARD path. ENTITY_EXTRACTOR_AGENT.md: preferred_name ownership clarified (Phase 0 is authoritative). Grading criteria rewritten as purely study-design-based (E3 = multiple cohorts/meta-analysis/guidelines; E2 = single cohort or RCT; E1 = animal/in vitro/mechanistic). CONTROLLED_VOCABULARY.md: typical_specimens and amr_highlights added to closed-vocab mapping list. SKILL.md Quick Start output #4: UNCERTAIN added. |
| 2.2 | 2026-04-01 | **Extraction rule completeness pass:** added synonym rule (NCBI Common names only); added key_traits controlled vocabulary; added is_pathobiont decision rule; added clinical_roles mapping guidance; restricted ecology/bloom_trigger scope to Results/Discussion only; added biology null-rule for supra-species ranks; added association_text format rule; added paper_summary per-taxon scope rule. **Integrity fixes:** resolved UNCERTAIN grade contradiction (staging file always written); resolved AMBIGUOUS routing contradiction (no mid-skill stops; staging file written with flag); corrected grading_agent phase label (Phase 2→Phase 1); added Phase 1→2 merge step to workflow; added cross_check_flags orphan file (`staging/YYYY-MM-DD_cross-check-flags.json`); fixed wrong MeSH anatomy IDs in MESH_AGENT.md example (gut D007422, stool D005243); added Metabolites section to TAXON_PASSPORT.md template; fixed TAXON_PASSPORT_EXAMPLE.md passport_id (MCA-BAC-000007) and synonym (NCBI only); added kegg_mirror_path to KEGG_AGENT.md inputs. |
| 2.1 | 2026-04-01 | Added 3 Phase 2 enrichment agents: mesh_agent (NLM MeSH), kegg_agent (KEGG Disease/Drug/Compound), aro_agent (CARD/ARO); grading_agent moved to Phase 1; workflow expanded to 4 phases; Phase 2 is best-effort/non-blocking |
| 2.0 | 2026-04-01 | Schema v2.0: domain field, ext-id objects for niches/specimens/triggers/AMR, metabolites, assoc_refs, evidence_type on associations; routing agent uses current XML glob; downstream skill reference corrected |
| 1.1 | 2026-03-31 | Input is always a PDF; filename stem is the PMID; added pre-phase filename validation (halt if not digits-only 1–8 chars) |
| 1.0 | 2026-03-31 | Initial version: 4-agent pipeline, 3-phase workflow, CREATE/UPDATE routing, staging file output |
