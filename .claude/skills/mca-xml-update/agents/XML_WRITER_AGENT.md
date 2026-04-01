---
name: xml_writer_agent
description: "Applies a single MCA staging JSON file to a new versioned XML snapshot. Handles both CREATE (new TaxonPassport) and UPDATE (enrich existing passport) actions. Reads from the current XML file and writes to a new output file — never overwrites. Called by the mca-xml-update skill orchestrator. Never called directly by the user."
---

# XML Writer Agent — MCA XML Update

Applies one staging JSON file to a new versioned XML snapshot. Receives a fully validated staging file (validation is done by the orchestrator in Phase 0). Reads the current XML, performs the CREATE or UPDATE action, and writes the result to the output XML path (a new file — the source is never overwritten). Returns a structured report to the orchestrator.

See `.claude/references/VERSIONING.md` for the version string format and snapshot behaviour.

---

## Inputs (provided by orchestrator)

| Input | Description |
|-------|-------------|
| `staging_file_path` | Absolute path to the staging JSON file |
| `source_xml_path` | Absolute path to the current (input) XML file, e.g. `database/MCA_DB_v0_1_20260303.xml` |
| `output_xml_path` | Absolute path for the new output XML file, e.g. `database/MCA_DB_v0_1_20260331.xml` — provided by orchestrator, never equal to `source_xml_path` |
| `output_version_string` | Full version string for this output file, e.g. `v0_1_20260331` — applied to `<version>` on all created/updated passports |
| `assigned_passport_id` | Pre-assigned ID for CREATE actions (e.g., `MCA-BAC-000016`); `null` for UPDATE |

---

## Outputs (returned to orchestrator)

```json
{
  "status": "success | error",
  "action": "CREATE | UPDATE",
  "passport_id": "MCA-BAC-000016",
  "taxon_name": "Clostridioides difficile",
  "fields_written": ["ecology.bloom_triggers", "clinical_associations (2 added)"],
  "scalar_overwrites": ["is_pathobiont: null → yes"],
  "skipped_fields": [],
  "error": null
}
```

---

## Execution Steps

### Step 1 — Read inputs

1. Read and parse the staging JSON from `staging_file_path`.
2. Read the current XML from `source_xml_path`.
3. Confirm `action` is `CREATE` or `UPDATE`.
4. Confirm `output_xml_path` does not already exist. If it does (another agent in this session already created it), read from `output_xml_path` instead of `source_xml_path` — the orchestrator reuses the same output file across sequential agent calls within one session.

---

### Step 2A — CREATE action

1. Use `assigned_passport_id` as the `<passport_id>` value.
2. Build a new `<TaxonPassport>` block with:
   - Core fields from `proposed_changes.identity`:
     `preferred_name`, `taxon_rank`, `lineage`, `ncbi_taxid`
   - `is_pathobiont` from `proposed_changes.clinical_profile.is_pathobiont`
   - `last_reviewed` from staging file root
   - `version` — set to `output_version_string` (e.g. `v0_1_20260331`)
   - `created_at` and `updated_at` — set to today's date (ISO 8601: `YYYY-MM-DD HH:MM:SS`)
3. Append all satellite child elements with non-null values (see XML Structure below).
4. Insert the new `<TaxonPassport>` block at the end of the XML, before the closing `</MicrobialClinicalAtlas>` tag.
5. Preserve 1-space indentation throughout.

---

### Step 2B — UPDATE action

1. Locate the `<TaxonPassport>` node where `<passport_id>` matches the staging file's `passport_id`.
2. For each field in `proposed_changes` that is non-null:

   **Scalar fields** (`gram_status`, `oxygen_tolerance`, `morphology`, `is_pathobiont`, `taxon_rank`, `lineage`, `ncbi_taxid`):
   - If the existing XML element is empty or absent: set the value.
   - If the existing XML element has a value: overwrite and record in `scalar_overwrites`.

   **List fields** (all arrays: `synonyms`, `key_traits`, `primary_niches`, `reservoirs`, `transmission_routes`, `clinical_roles`, `typical_specimens`, `bloom_triggers`, `risk_contexts`, `amr_highlights`, `taxon_level_pmids`):
   - Collect existing values from XML for this field.
   - Append only items not already present (case-insensitive exact match).
   - Skip exact duplicates silently.

   **`clinical_associations`**:
   - Each item in the staging array is a new claim. Append all as new `<ClinicalAssociation>` elements.
   - Do not deduplicate clinical associations — each paper's claim is a distinct record even if similar text exists.

   **`last_reviewed`**: Always overwrite with the staging file value.
   **`updated_at`**: Always set to today's date.
   **`version`**: Always set to `output_version_string` on any touched passport.

3. If a proposed satellite section (e.g., `<Biology>`, `<Ecology>`) does not yet exist on the passport node, create it as a new child element block.

---

### Step 3 — Write XML

1. Write the modified XML to `output_xml_path`. Never write to `source_xml_path`.
2. If `output_xml_path` already exists (created by a prior agent call in this session), overwrite it — it is the in-progress output file for this session, not a historical snapshot.
3. Preserve:
   - XML declaration line: `<?xml version="1.0" encoding="UTF-8"?>`
   - 1-space indentation
   - Existing element order within each `<TaxonPassport>` node
4. Do not reformat or re-indent unmodified passports.

---

### Step 4 — Return report

Return the output object (see Outputs above) to the orchestrator with:
- `status: "success"` if write completed without error
- `status: "error"` with `error` field populated if any step failed
- Full list of `fields_written`, `scalar_overwrites`, and `skipped_fields`

---

## XML Structure Reference

### Core passport fields (always present)

```xml
<TaxonPassport>
  <passport_id>MCA-BAC-000016</passport_id>
  <preferred_name>Clostridioides difficile</preferred_name>
  <taxon_rank>species</taxon_rank>
  <lineage>Bacteria|...</lineage>
  <ncbi_taxid>1496</ncbi_taxid>
  <is_pathobiont>yes</is_pathobiont>
  <last_reviewed>2026-03-31</last_reviewed>
  <version>v0.1</version>
  <created_at>2026-03-31 00:00:00</created_at>
  <updated_at>2026-03-31 00:00:00</updated_at>
</TaxonPassport>
```

### Satellite child element blocks (added when data is present)

```xml
<TaxonPassport>
  <!-- core fields ... -->

  <Synonyms>
    <synonym>C. diff</synonym>
    <synonym>Clostridium difficile</synonym>
  </Synonyms>

  <Biology>
    <gram_status>gram-positive</gram_status>
    <oxygen_tolerance>anaerobe</oxygen_tolerance>
    <morphology>rod</morphology>
    <KeyTraits>
      <key_trait>spore-forming</key_trait>
      <key_trait>toxin-producing</key_trait>
    </KeyTraits>
  </Biology>

  <Ecology>
    <PrimaryNiches>
      <primary_niche>gut</primary_niche>
    </PrimaryNiches>
    <Reservoirs>
      <reservoir>human</reservoir>
      <reservoir>environment</reservoir>
    </Reservoirs>
    <TransmissionRoutes>
      <transmission_route>fecal-oral</transmission_route>
    </TransmissionRoutes>
  </Ecology>

  <ClinicalProfile>
    <ClinicalRoles>
      <clinical_role>opportunistic pathogen</clinical_role>
    </ClinicalRoles>
    <TypicalSpecimens>
      <typical_specimen>stool</typical_specimen>
    </TypicalSpecimens>
    <BloomTriggers>
      <bloom_trigger>antibiotic exposure</bloom_trigger>
    </BloomTriggers>
    <RiskContexts>
      <risk_context>ICU / critical care</risk_context>
    </RiskContexts>
    <AmrHighlights>
      <amr_highlight>fluoroquinolone resistance</amr_highlight>
    </AmrHighlights>
  </ClinicalProfile>

  <TaxonEvidencePmids>
    <pmid>12345678</pmid>
  </TaxonEvidencePmids>

  <ClinicalAssociations>
    <ClinicalAssociation>
      <association_text>...</association_text>
      <evidence_grade>E2</evidence_grade>
      <Pmids>
        <pmid>12345678</pmid>
      </Pmids>
    </ClinicalAssociation>
  </ClinicalAssociations>

</TaxonPassport>
```

---

## Rules and Constraints

- **Never delete existing XML elements.** Only add or update.
- **Never modify passports other than the target** identified by `passport_id`.
- **Null fields in staging are skipped** — do not write empty XML elements for null values.
- **Empty arrays `[]` are skipped** — do not write empty container elements.
- **Clinical association PMIDs** may be empty (PMID pending confirmation) — write the `<ClinicalAssociation>` block with an empty `<Pmids/>` element and record in `skipped_fields`.
- **Do not validate controlled vocabulary** — that is done by the orchestrator in Phase 0. Write what is in the staging file.

---

## Error Handling

| Error | Behaviour |
|-------|-----------|
| Staging JSON unparseable | Return `status: "error"`, halt |
| XML unparseable | Return `status: "error"`, halt |
| UPDATE: `passport_id` not found in XML | Return `status: "error"`, halt |
| CREATE: `assigned_passport_id` is null | Return `status: "error"`, halt |
| `output_xml_path` equals `source_xml_path` | Return `status: "error"`, halt — never overwrite source |
| `output_version_string` missing or malformed | Return `status: "error"`, halt |
| File write failure | Return `status: "error"` with OS error message |
