---
name: mca-xml-update
description: "MCA XML update skill. Reads one or more approved staging JSON files from staging/, validates them, applies CREATE or UPDATE actions to database/MCA_DB_vX.X.xml, archives applied files, and runs xml2sql.py to generate a .sql dump. Triggers on: apply staging file, update MCA XML, apply to database, commit staging, import staging."
metadata:
  version: "2.4"
  last_updated: "2026-05-06"
---

# MCA XML Update Skill v2.4 — Apply Staging Files to the Knowledge Base

Reads one or more approved staging JSON files from `staging/`, validates them, applies each CREATE or UPDATE action to `database/MCA_DB_vX.X.xml` via a dedicated `xml_writer_agent`, archives applied files to `staging/applied/`, and generates a `.sql` dump via `xml2sql.py`.

> **Prerequisite:** Staging files must already exist (produced by the MCA Paper Curator skill). This skill does not extract or grade — it only applies approved changes.
>
> **Fresh-start support:** If no `database/MCA_DB_v*.xml` exists, `xsd_writer_agent` is automatically invoked to bootstrap a skeleton XML before applying any staging files. No manual setup is required.

---

## Quick Start

```
Apply staging file: staging/38123456_2026-03-31_clostridioides-difficile.json
```

```
Apply all staging files
```

**Output:**
1. Validation report for each staging file (warnings shown, hard failures block execution)
2. Changes applied to `database/MCA_DB_vX.X.xml`
3. Applied files moved to `staging/applied/`
4. `.sql` dump generated at `database/MCA_DB_[version].sql`
5. Summary of new passport IDs assigned and fields updated

---

## Trigger Conditions

**Trigger keywords:** apply staging file, update MCA XML, apply to database, commit staging, import staging, apply approved

**Non-trigger scenarios:**

| Scenario | What to do instead |
|----------|--------------------|
| Extracting data from a paper | Use the MCA Paper Curator skill (Skill 1) |
| Manually editing a specific passport field | Edit `database/MCA_DB_vX.X.xml` directly |
| Reviewing or inspecting a staging file | Read the file directly — no skill needed |

---

## Agent Team (2 Agents)

| # | Agent | Role | Phase |
|---|-------|------|-------|
| 1 | `xsd_writer_agent` | Bootstraps a fresh database: generates `MCA_schema.xsd` and an empty skeleton XML; invoked only when no `MCA_DB_v*.xml` exists | Phase 2 (conditional) |
| 2 | `xml_writer_agent` | Applies a single staging file's CREATE or UPDATE action to the XML | Phase 2 |

One `xml_writer_agent` is spawned per staging file. Files are processed sequentially (not in parallel) to avoid write conflicts on the shared XML. `xsd_writer_agent` is spawned at most once per session, only on a fresh database.

---

## Orchestration Workflow (3 Phases)

```
User: "Apply staging file(s)" + [file path(s) or "all"]
     |
=== Phase 0: DISCOVERY & VALIDATION ===
     |
     +-> Resolve which staging files to apply:
         - Explicit path(s) provided by user: use those files
         - "all" or no path given: glob staging/*.json (excluding staging/applied/)
         - For each file:
             * Validate JSON parses correctly
             * Check required fields: action, last_reviewed, evidence.grade,
               proposed_changes (at least one non-null section)
             * For UPDATE: confirm passport_id exists in MCA_DB_vX.X.xml
             * For CREATE: confirm taxon is NOT already in XML (by preferred_name,
               synonym, or ncbi_taxid)
             * Flag warnings (do not block):
                 - evidence.grade is UNCERTAIN
                 - Any clinical_association has empty pmids []
                 - extraction_notes is non-empty
                 - source_paper.pmid is null
     |
=== Phase 1: PRE-FLIGHT SUMMARY (non-blocking) ===
     |
     +-> Present to user (informational only — does not pause for confirmation):
         ┌─────────────────────────────────────────────┐
         │  Files to apply: N                          │
         │  CREATEs: X  |  UPDATEs: Y                 │
         │                                             │
         │  [CREATE] <taxon_name>                      │
         │    → New passport ID will be assigned       │
         │    → Fields: identity, biology, ecology ... │
         │                                             │
         │  [UPDATE] <taxon_name> (MCA-BAC-000001)     │
         │    → Append: bloom_triggers (3), ...        │
         │    → Add: 2 clinical associations           │
         │                                             │
         │  ⚠  Warnings (non-blocking):               │
         │    - <file>: PMID missing on 2 associations │
         │    - <file>: evidence grade is UNCERTAIN    │
         └─────────────────────────────────────────────┘
         Proceed immediately to Phase 2.
     |
=== Phase 2: APPLY VIA xml_writer_agent ===
     |
     +-> Locate the most recent XML snapshot:
         - Glob database/MCA_DB_v*.xml; sort by version string descending; use the latest
         - If NO XML file found (fresh database):
             → Invoke xsd_writer_agent with:
                 output_version_string = "v0_1_YYYYMMDD" (today's date)
                 output_xml_path       = "database/MCA_DB_v0_1_YYYYMMDD.xml"
                 output_xsd_path       = "database/MCA_schema.xsd"
             → On success: use output_xml_path as source_xml_path and proceed
             → On error: halt; report xsd_writer_agent error to user
         - Set source_xml_path to the located (or just-generated) file
     +-> Determine output filename before processing:
         - Read current MAJOR and MINOR from the source XML filename
         - Set YYYYMMDD to today's date
         - output_version_string = vMAJOR_MINOR_YYYYMMDD (e.g. v0_1_20260331)
         - output_xml_path = database/MCA_DB_[output_version_string].xml
         - If output_xml_path == source_xml_path (same-day source — YYYYMMDD matches):
             → Auto-bump MINOR by 1: output_version_string = vMAJOR_(MINOR+1)_YYYYMMDD
             → output_xml_path = database/MCA_DB_[new_version_string].xml
             → Inform the user in the pre-flight summary: "Source XML was created today;
               bumping MINOR to avoid overwrite: [new_version_string]"
     +-> For each staging file (sequentially):
         Spawn xml_writer_agent with:
           - Path to staging JSON
           - source_xml_path (first agent) or output_xml_path (subsequent agents,
             since output file already exists from prior agent in this session)
           - output_xml_path (same for all agents in this session)
           - output_version_string
           - Next available passport_id (for CREATE actions only)
         Agent returns:
           - passport_id assigned (CREATE) or updated (UPDATE)
           - List of fields written / appended
           - Any errors or skipped fields
     |
=== Phase 3: ARCHIVE & REPORT ===
     |
     +-> Move each successfully applied staging file to staging/applied/
         (create staging/applied/ if it does not exist)
     +-> Append one entry per successfully applied file to database/curation_log.json:
         - Read existing log array (or start with [] if file does not exist)
         - Append entry:
             {
               "date_applied": "YYYY-MM-DD",
               "passport_id": "MCA-BAC-000001",
               "preferred_name": "Taxon name",
               "action": "CREATE | UPDATE",
               "source_pmid": 12345678,
               "xml_file": "database/MCA_DB_vX_X_YYYYMMDD.xml",
               "staging_file": "staging/applied/PMID_YYYY-MM-DD_taxon-name.json"
             }
         - Write updated array back to database/curation_log.json (pretty-printed, 2-space indent)
     +-> Run xml2sql.py to generate a .sql dump of the updated XML:
         - Command: python3 database/xml2sql.py <output_xml_path>
         - Output: database/MCA_DB_[output_version_string].sql (same stem as XML, .sql extension)
         - Run after all staging files have been applied (once per session, not per file)
         - If xml2sql.py fails, log the error in the report but do not fail the overall session
     +-> Report to user:
         - Output XML: database/MCA_DB_[output_version_string].xml (new file)
         - Source XML preserved: database/MCA_DB_[previous_version_string].xml
         - SQL dump: database/MCA_DB_[output_version_string].sql
         - Files applied: N
         - New passport IDs assigned: [list]
         - Fields updated per taxon: [summary]
         - Files archived to staging/applied/
         - Log updated: database/curation_log.json
         - Any files skipped and why
```

---

## Checkpoint Rules

1. **Phase 0 — validate before touching XML**: Never write to the XML if any staging file fails hard validation (malformed JSON, missing required fields, UPDATE with unknown passport_id). Warn-only issues (missing PMIDs, UNCERTAIN grade) do not block — they are shown in the Phase 1 summary. **Batch failure scope: if even one file in the batch fails hard validation, no files in the batch are written to the XML.** Valid files are not applied while invalid ones are held back — the entire batch is blocked until the user resolves the hard failure and resubmits.
2. **Phase 1 — non-blocking summary**: Show the pre-flight summary and any warnings, then proceed immediately to Phase 2 without pausing for user confirmation.
3. **Phase 2 — sequential writes**: Process one staging file at a time. Never run multiple `xml_writer_agent` calls in parallel — they write to the same XML file.
4. **Phase 2 — no removal of existing data**: UPDATE actions may only append to list fields and overwrite scalar fields if a new value is explicitly provided. Never delete existing XML elements.
5. **Phase 3 — archive on success only**: Only move a staging file to `staging/applied/` if the agent confirms it was applied without errors.
6. **Phase 3 — xml2sql runs once per session**: Run `python3 database/xml2sql.py <output_xml_path>` once after all staging files have been applied. A failure here does not roll back the XML writes.

---

## passport_id Assignment (CREATE)

New passport IDs are assigned by the orchestrator before calling `xml_writer_agent`, based on the current highest ID in the XML.

**Format:** `MCA-[DOMAIN]-[NNNNNN]`

| Domain prefix | Taxon domain |
|---------------|-------------|
| `BAC` | Bacteria |
| `FUN` | Fungi |
| `VIR` | Viruses / Phages |
| `ARC` | Archaea |

**Derivation:** Inspect `proposed_changes.identity.lineage` (first element) or `proposed_changes.identity.domain` to determine the domain prefix. If neither is present and the domain cannot be inferred, **halt Phase 2 immediately, report the ambiguity to the user inline** (e.g., `"Cannot assign passport_id for [taxon]: domain not determinable from staging file. Please add identity.domain (Bacteria | Archaea | Fungi | Virus | Eukaryote) to the staging file and resubmit."`), and skip this staging file. Do not guess the domain. Other files in the batch that are unambiguous continue processing.

**Increment rule:** Find the highest existing `NNNNNN` for the relevant domain prefix across all passports in the XML; increment by 1 and zero-pad to 6 digits. If the XML is a fresh skeleton with no passports, start at `000001`.

---

## UPDATE Diff Rules (mirroring `.claude/skills/mca-paper-curator/templates/STAGING_FILE.md`)

| Field type | Behaviour |
|------------|-----------|
| Scalar (e.g., `gram_status`, `is_pathobiont`) | Overwrite with new value; flag in report if overwriting a non-null existing value |
| List (e.g., `synonyms`, `bloom_triggers`, `metabolites`, `clinical_associations`) | Append new items; skip exact duplicates (matched on `value` for tag objects) |
| `last_reviewed` | Always update to the value in the staging file |
| `updated_at` | Set to today's date (ISO 8601) |
| Fields absent from `proposed_changes` (null or omitted) | Leave XML untouched |

---

## XML Structure Notes

Full element-level structure is defined in `agents/XML_WRITER_AGENT.md`.

**Core fields:** `<passport_id>`, `<preferred_name>`, `<taxon_rank>`, `<domain>`, `<lineage>`, `<ncbi_taxid>`, `<is_pathobiont>`, `<last_reviewed>`, `<created_at>`, `<updated_at>`. Note: `<version>` is no longer a per-passport field.

**Ext-ID attributes on tag elements:** Body-site tags (`<primary_niche>`, `<typical_specimen>`) carry a `mesh_anatomy_id` attribute; `<bloom_trigger>` carries `kegg_drug_id`; `<amr_highlight>` carries `aro_id`. Omit the attribute entirely when the ID is null.

**New sections:** `<Metabolites>` (produces/consumes/modifies relationships + KEGG/ChEBI IDs); `<AssocRefs>` inside each `<ClinicalAssociation>` (MeSH and KEGG Disease IDs).

**`content_hash` on associations:** The `xml_writer_agent` computes a SHA-256 hash of the lowercased, whitespace-normalised `association_text` and writes it as `<content_hash>`. This is never provided in the staging file — always derived on write.

**Adding new child elements:** When a staging file proposes satellite fields for an existing passport that has none, `xml_writer_agent` adds them as new child element blocks under the existing `<TaxonPassport>` node. This is expected — it enriches passports progressively.

**Preserve formatting:** Maintain 1-space indentation and existing element order when writing back to the XML.

---

## Staging File Archive

```
staging/
├── PMID_YYYY-MM-DD_taxon-name.json       ← pending (not yet applied)
└── applied/
    └── PMID_YYYY-MM-DD_taxon-name.json   ← applied (archived here after write)
```

Applied files are never deleted — they serve as the audit trail of what was imported and when.

---

## Validation Checklist (Phase 0)

**Hard failures (block execution):**
- [ ] JSON is valid and parseable
- [ ] `action` is `CREATE` or `UPDATE`
- [ ] `last_reviewed` is a valid `YYYY-MM-DD` date
- [ ] `evidence.grade` is present (`E1`, `E2`, `E3`, or `UNCERTAIN`)
- [ ] `proposed_changes` has at least one non-null section
- [ ] For UPDATE: `passport_id` is non-null and exists in the XML
- [ ] For CREATE: taxon not already present in XML (by name, synonym, or ncbi_taxid)

**Warnings (surface in pre-flight, do not block):**
- [ ] `evidence.grade` is `UNCERTAIN`
- [ ] Any clinical association has `pmids: []`
- [ ] `source_paper.pmid` is null
- [ ] `extraction_notes` is non-empty (review notes before confirming)

---

## Integration

```
[Skill 1: mca-paper-curator]
        |
   staging/PMID_YYYY-MM-DD_[taxon].json   ← human reviews & approves
        |
   [THIS SKILL: mca-xml-update]
        |
   database/MCA_DB_vX.X.xml (updated)
   database/MCA_DB_vX.X.sql  (generated by xml2sql.py)
        |
   staging/applied/PMID_YYYY-MM-DD_[taxon].json (archived)
```

---

## Agent File References

| Agent | Definition File |
|-------|----------------|
| `xsd_writer_agent` | `agents/XSD_WRITER_AGENT.md` |
| `xml_writer_agent` | `agents/XML_WRITER_AGENT.md` |

---

## Version Info

| Item | Content |
|------|---------|
| Skill Version | 2.4 |
| Last Updated | 2026-05-06 |
| Maintainer | Heewon Seo |
| Input | `staging/PMID_YYYY-MM-DD_[taxon].json` (one or more) |
| Output | New `database/MCA_DB_vMAJOR_MINOR_YYYYMMDD.xml` + `.sql` dump + archived staging files |
| Upstream Skill | MCA Paper Curator (Skill 1) |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.4 | 2026-05-06 | Phase 3: removed the `web/data/MCA_DB_latest.xml` copy step. The stable-download-link contract retired — `about.php` now points users to GitHub Releases for versioned XML/SQL artifacts. Removed Checkpoint Rule 7. |
| 2.3 | 2026-04-02 | Phase 2: same-day collision now explicitly auto-bumps MINOR in workflow (previously only documented in changelog). Version header corrected from 2.2 → 2.3. Phase 3: after xml2sql, copy output XML to `web/data/MCA_DB_latest.xml` (stable web-accessible path, decoupled from versioned filenames). Added Checkpoint Rule 7. |
| 2.2 | 2026-04-01 | Added `xsd_writer_agent` (Phase 2, conditional): when no `MCA_DB_v*.xml` exists, bootstraps a skeleton XML and `MCA_schema.xsd` before proceeding. Enables "start from scratch" workflow. |
| 2.1 | 2026-04-01 | Removed Phase 1 mandatory confirmation — pre-flight summary is now informational only; skill proceeds automatically. Added xml2sql.py execution in Phase 3 to generate a `.sql` dump after each session. |
| 2.0 | 2026-04-01 | Schema v2.0: domain field, ext-id attributes on tag elements, Metabolites section, AssocRefs on associations, content_hash computed on write, version removed from per-passport fields |
| 1.0 | 2026-03-31 | Initial version: single xml_writer_agent, batch support, pre-flight confirmation, staging archive |
