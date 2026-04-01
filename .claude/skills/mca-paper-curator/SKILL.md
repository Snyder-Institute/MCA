---
name: mca-paper-curator
description: "MCA curation skill for extracting clinically meaningful microbial entities and relationships from a research paper (PDF) and writing a structured staging file for human review. Covers paper analysis, entity extraction, CREATE/UPDATE routing against the existing XML, and evidence grading via a dedicated subagent. Triggers on: curate paper, add paper to MCA, extract from paper, curate taxon, update passport."
metadata:
  version: "1.0"
  last_updated: "2026-03-31"
---

# MCA Paper Curator v1.0 — Microbiome Knowledge Base Curation Skill

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
4. Evidence grade (E1 / E2 / E3) with written rationale
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

## Agent Team (4 Agents)

| # | Agent | Role | Phase |
|---|-------|------|-------|
| 1 | `paper_analyst_agent` | Reads the PDF; extracts paper metadata (PMID, title, authors, journal, year, study design, population, sample size) and identifies all taxa mentioned | Phase 0 |
| 2 | `entity_extractor_agent` | Maps paper findings to MCA entity model fields (biology, ecology, clinical profile, clinical associations) per taxon | Phase 1 |
| 3 | `routing_agent` | Checks each taxon against `database/MCA_DB_v0.1.xml`; determines CREATE (new passport) or UPDATE (existing passport); identifies `passport_id` for updates | Phase 1 |
| 4 | `grading_agent` | Assigns a single evidence grade (E1 / E2 / E3) for the whole paper with written rationale; flags uncertainty when study design is ambiguous or unreported | Phase 2 |

---

## Orchestration Workflow (3 Phases)

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
         - Writes paper summary into staging file (no user confirmation required)
     |
=== Phase 1: ENTITY EXTRACTION & ROUTING (parallel) ===
     |
     |-> [entity_extractor_agent]
     |   Per taxon identified in Phase 0:
     |   - Biology: gram status, oxygen tolerance, morphology, key traits
     |   - Ecology: primary niches, reservoirs, transmission routes
     |   - Clinical profile: pathobiont status, clinical roles, typical specimens,
     |                        bloom triggers, risk contexts, AMR highlights
     |   - Clinical associations: claim text extracted or inferred from paper findings
     |   - Only extract what the paper explicitly reports; leave unknown fields blank
     |
     +-> [routing_agent] (parallel with entity_extractor_agent)
         - Searches MCA_DB_v0.1.xml by preferred_name, synonym, and ncbi_taxid
         - Decision per taxon:
             CREATE — taxon not found in XML; full new passport required
             UPDATE — taxon found; identify passport_id and diff proposed changes
                      against existing fields
     |
=== Phase 2: EVIDENCE GRADING ===
     |
     +-> [grading_agent] (see agents/GRADING_AGENT.md)
         - Receives: paper metadata + study design from Phase 0
         - Assigns ONE grade for the entire paper (applied to all extracted associations)
         - Grades: E3 (strong clinical) / E2 (moderate) / E1 (limited/preliminary)
         - Writes rationale (2-3 sentences citing specific study design features)
         - Flags UNCERTAIN if study design is ambiguous or not reported
     |
=== Phase 3: STAGING FILE OUTPUT ===
     |
     +-> Compile all outputs into staging JSON
         - One file per taxon: staging/YYYY-MM-DD_[taxon-name].json
         - Schema follows templates/STAGING_FILE.md
         - Includes: action, passport_id (if UPDATE), paper metadata, evidence grade,
                     rationale, last_reviewed date, proposed_changes
     |
     ** Inform user of staging file path(s); no XML is modified at this step **
```

---

## Checkpoint Rules

0. **Pre-phase — filename validation**: If the filename stem is not digits-only (1–8 chars), halt immediately and ask the user to rename the file; do not proceed
1. **No mid-skill stops**: The skill runs end-to-end (Phase 0 → Phase 3) without pausing for user confirmation at any phase boundary. The user reviews everything in the final staging file.
1. **Phase 0 — paper summary**: Written directly into the staging file; no user confirmation required; PMID is always taken from the filename, not the PDF text
2. **Phase 1 — extraction boundary**: Only extract what the paper explicitly states; do not infer or embellish beyond reported findings
3. **Phase 1 — UPDATE diff**: For UPDATE actions, only propose fields that differ from what is already in the XML; do not overwrite unchanged fields
4. **Phase 2 — one grade per paper**: A single evidence grade applies to the whole paper and all associations extracted from it
5. **Phase 2 — uncertainty flag**: If study design cannot be determined, `grading_agent` must flag `UNCERTAIN` rather than guess; the staging file is still written with `UNCERTAIN` flagged for human review
6. **Phase 3 — no XML writes**: This skill ends at writing the staging file; the XML is never touched here

---

## CREATE vs UPDATE Rules

| Scenario | Action | Behaviour |
|----------|--------|-----------|
| Taxon not in XML (by name, synonym, or TaxID) | CREATE | Fill all extractable fields from paper; leave unknown fields blank or `null` |
| Taxon found in XML | UPDATE | Propose additions to existing fields and new clinical associations; do not remove or overwrite existing data without explicit user instruction |
| Taxon found under a synonym | UPDATE | Match to existing passport; note the synonym used in the paper |
| Taxon is ambiguous (e.g., genus-level vs species-level) | Flag for user | Present both options; user selects before proceeding |

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
| Skill Version | 1.1 |
| Last Updated | 2026-03-31 |
| Maintainer | Heewon Seo |
| Input | Research paper (PDF); filename stem must be the PMID (digits only, e.g. `38123456.pdf`) |
| Output | `staging/YYYY-MM-DD_[taxon-name].json` |
| Downstream Skill | MCA XML Update Skill (Skill 2, not yet written) |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2026-03-31 | Input is always a PDF; filename stem is the PMID; added pre-phase filename validation (halt if not digits-only 1–8 chars) |
| 1.0 | 2026-03-31 | Initial version: 4-agent pipeline, 3-phase workflow, CREATE/UPDATE routing, staging file output |
