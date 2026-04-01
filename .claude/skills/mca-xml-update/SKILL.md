---
name: mca-xml-update
description: "MCA XML update skill. Reads one or more approved staging JSON files from staging/, validates them, applies CREATE or UPDATE actions to database/MCA_DB_vX.X.xml, and archives applied files. Triggers on: apply staging file, update MCA XML, apply to database, commit staging, import staging."
metadata:
  version: "2.0"
  last_updated: "2026-03-31"
---

# MCA XML Update Skill v1.0 — Apply Staging Files to the Knowledge Base

Reads one or more approved staging JSON files from `staging/`, validates them, shows a pre-flight summary for human confirmation, applies each CREATE or UPDATE action to `database/MCA_DB_vX.X.xml` via a dedicated `xml_writer_agent`, and archives applied files to `staging/applied/`.

> **Prerequisite:** Staging files must already exist (produced by the MCA Paper Curator skill). This skill does not extract or grade — it only applies approved changes.

---

## Quick Start

```
Apply staging file: staging/2026-03-31_clostridioides-difficile.json
```

```
Apply all staging files
```

**Output:**
1. Validation report for each staging file (warnings flagged before any writes)
2. Pre-flight summary — CREATEs, UPDATEs, warnings — awaiting user confirmation
3. Changes applied to `database/MCA_DB_vX.X.xml`
4. Applied files moved to `staging/applied/`
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

## Agent Team (1 Agent)

| # | Agent | Role | Phase |
|---|-------|------|-------|
| 1 | `xml_writer_agent` | Applies a single staging file's CREATE or UPDATE action to the XML | Phase 2 |

One `xml_writer_agent` is spawned per staging file. Files are processed sequentially (not in parallel) to avoid write conflicts on the shared XML.

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
=== Phase 1: PRE-FLIGHT SUMMARY & CONFIRMATION ===
     |
     +-> Present to user:
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
         │  ⚠  Warnings (review before confirming):   │
         │    - <file>: PMID missing on 2 associations │
         │    - <file>: evidence grade is UNCERTAIN    │
         └─────────────────────────────────────────────┘
         ** STOP — await explicit user confirmation before proceeding **
         If user says no or requests changes, stop here.
     |
=== Phase 2: APPLY VIA xml_writer_agent ===
     |
     +-> Determine output filename before processing:
         - Read current MAJOR and MINOR from the source XML filename
         - Set YYYYMMDD to today's date
         - output_version_string = vMAJOR_MINOR_YYYYMMDD (e.g. v0_1_20260331)
         - output_xml_path = database/MCA_DB_[output_version_string].xml
         - Confirm output_xml_path != source_xml_path (guard against same-day source)
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
               "staging_file": "staging/applied/YYYY-MM-DD_taxon-name.json"
             }
         - Write updated array back to database/curation_log.json (pretty-printed, 2-space indent)
     +-> Report to user:
         - Output XML: database/MCA_DB_[output_version_string].xml (new file)
         - Source XML preserved: database/MCA_DB_[previous_version_string].xml
         - Files applied: N
         - New passport IDs assigned: [list]
         - Fields updated per taxon: [summary]
         - Files archived to staging/applied/
         - Log updated: database/curation_log.json
         - Any files skipped and why
```

---

## Checkpoint Rules

1. **Phase 0 — validate before touching XML**: Never write to the XML if any staging file fails hard validation (malformed JSON, missing required fields, UPDATE with unknown passport_id). Warn-only issues (missing PMIDs, UNCERTAIN grade) do not block — they are surfaced in Phase 1.
2. **Phase 1 — mandatory confirmation**: Always pause and show the pre-flight summary. Never apply changes without explicit user confirmation.
3. **Phase 2 — sequential writes**: Process one staging file at a time. Never run multiple `xml_writer_agent` calls in parallel — they write to the same XML file.
4. **Phase 2 — no removal of existing data**: UPDATE actions may only append to list fields and overwrite scalar fields if a new value is explicitly provided. Never delete existing XML elements.
5. **Phase 3 — archive on success only**: Only move a staging file to `staging/applied/` if the agent confirms it was applied without errors.

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

**Derivation:** Inspect `proposed_changes.identity.lineage` or `proposed_changes.biology` to determine domain. If ambiguous, ask the user before proceeding.

**Increment rule:** Find the highest existing `NNNNNN` for the relevant domain prefix across all passports in the XML; increment by 1 and zero-pad to 6 digits.

---

## UPDATE Diff Rules (mirroring STAGING_FILE.md)

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
├── YYYY-MM-DD_taxon-name.json       ← pending (not yet applied)
└── applied/
    └── YYYY-MM-DD_taxon-name.json   ← applied (archived here after write)
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
   staging/YYYY-MM-DD_[taxon].json   ← human reviews & approves
        |
   [THIS SKILL: mca-xml-update]
        |
   database/MCA_DB_vX.X.xml (updated)
        |
   staging/applied/YYYY-MM-DD_[taxon].json (archived)
```

---

## Agent File References

| Agent | Definition File |
|-------|----------------|
| `xml_writer_agent` | `agents/XML_WRITER_AGENT.md` |

---

## Version Info

| Item | Content |
|------|---------|
| Skill Version | 2.0 |
| Last Updated | 2026-04-01 |
| Maintainer | Heewon Seo |
| Input | `staging/YYYY-MM-DD_[taxon].json` (one or more) |
| Output | New `database/MCA_DB_vMAJOR_MINOR_YYYYMMDD.xml` + archived staging files |
| Upstream Skill | MCA Paper Curator (Skill 1) |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-04-01 | Schema v2.0: domain field, ext-id attributes on tag elements, Metabolites section, AssocRefs on associations, content_hash computed on write, version removed from per-passport fields |
| 1.0 | 2026-03-31 | Initial version: single xml_writer_agent, batch support, pre-flight confirmation, staging archive |
