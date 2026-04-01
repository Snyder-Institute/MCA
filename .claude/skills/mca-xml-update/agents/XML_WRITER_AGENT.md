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
2. Build a new `<TaxonPassport>` block with core fields from `proposed_changes.identity`:
   `preferred_name`, `taxon_rank`, `domain`, `lineage`, `ncbi_taxid`
   - `is_pathobiont` from `proposed_changes.clinical_profile.is_pathobiont`
   - `last_reviewed` from staging file root
   - `created_at` and `updated_at` — set to today's date (ISO 8601 date only: `YYYY-MM-DD`)
   - Do **not** write a `<version>` element — version is stored in `meta`, not per passport
3. Append all satellite child element blocks with non-null/non-empty values (see XML Structure below).
4. For `<ClinicalAssociation>` entries: compute `content_hash` as SHA-256 of the lowercased, whitespace-normalised `association_text` before writing.
5. Insert the new `<TaxonPassport>` block at the end of the XML, before the closing `</MicrobialClinicalAtlas>` tag.
6. Preserve 1-space indentation throughout.

---

### Step 2B — UPDATE action

1. Locate the `<TaxonPassport>` node where `<passport_id>` matches the staging file's `passport_id`.
2. For each field in `proposed_changes` that is non-null:

   **Scalar fields** (`gram_status`, `oxygen_tolerance`, `morphology`, `is_pathobiont`, `taxon_rank`, `lineage`, `ncbi_taxid`):
   - If the existing XML element is empty or absent: set the value.
   - If the existing XML element has a value: overwrite and record in `scalar_overwrites`.

   **List fields** (all arrays: `synonyms`, `key_traits`, `primary_niches`, `typical_specimens`, `bloom_triggers`, `amr_highlights`, `reservoirs`, `transmission_routes`, `clinical_roles`, `risk_contexts`, `metabolites`, `taxon_level_pmids`):
   - Collect existing values from XML for this field.
   - For plain-string fields: append only items not already present (case-insensitive exact match).
   - For object fields (`primary_niches`, `typical_specimens`, `bloom_triggers`, `amr_highlights`, `metabolites`): match on `value` (case-insensitive); skip if `value` already present, otherwise append. If a new entry has a non-null `ext_id` and the existing entry has none, update the attribute on the existing element.
   - Skip exact duplicates silently.

   **`clinical_associations`**:
   - Compute `content_hash` (SHA-256 of lowercased, whitespace-normalised `association_text`) before inserting.
   - Skip if a `<ClinicalAssociation>` with the same `content_hash` already exists under this passport.
   - Otherwise, append as a new `<ClinicalAssociation>` element including `<content_hash>`, `<evidence_type>`, `<AssocRefs>`, and `<Pmids>`.

   **`last_reviewed`**: Always overwrite with the staging file value.
   **`updated_at`**: Always set to today's date (`YYYY-MM-DD`).
   **`version`**: Do **not** write or update — version is in `meta`, not per passport.

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
  <domain>Bacteria</domain>
  <lineage>Bacteria|Bacillota|Clostridia|Eubacteriales|Peptostreptococcaceae|Clostridioides|Clostridioides difficile</lineage>
  <ncbi_taxid>1496</ncbi_taxid>
  <is_pathobiont>yes</is_pathobiont>
  <last_reviewed>2026-03-31</last_reviewed>
  <created_at>2026-03-31</created_at>
  <updated_at>2026-03-31</updated_at>
</TaxonPassport>
```

Note: `<version>` is no longer written per passport. DB version is stored in the `meta` table / a separate `<Meta>` block if needed.

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
    <oxygen_tolerance>obligate anaerobe</oxygen_tolerance>
    <morphology>bacillus (rod)</morphology>
    <KeyTraits>
      <key_trait>spore-forming</key_trait>
      <key_trait>toxin-producing</key_trait>
    </KeyTraits>
  </Biology>

  <Ecology>
    <PrimaryNiches>
      <!-- mesh_anatomy_id attribute omitted when null -->
      <primary_niche mesh_anatomy_id="D007408">gut</primary_niche>
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
      <!-- mesh_anatomy_id attribute omitted when null -->
      <typical_specimen mesh_anatomy_id="D070101">stool</typical_specimen>
    </TypicalSpecimens>
    <BloomTriggers>
      <!-- kegg_drug_id attribute omitted when null -->
      <bloom_trigger kegg_drug_id="D00806">antibiotic exposure</bloom_trigger>
    </BloomTriggers>
    <RiskContexts>
      <risk_context>ICU / critical care</risk_context>
    </RiskContexts>
    <AmrHighlights>
      <!-- aro_id attribute omitted when null -->
      <amr_highlight aro_id="ARO:3000026">ESBL-producing</amr_highlight>
    </AmrHighlights>
  </ClinicalProfile>

  <Metabolites>
    <Metabolite>
      <metabolite_name>butyric acid</metabolite_name>
      <relationship>produces</relationship>
      <kegg_compound_id>C00246</kegg_compound_id>
      <chebi_id>CHEBI:17968</chebi_id>
    </Metabolite>
  </Metabolites>

  <TaxonEvidencePmids>
    <pmid>12345678</pmid>
  </TaxonEvidencePmids>

  <ClinicalAssociations>
    <ClinicalAssociation>
      <association_text>...</association_text>
      <content_hash>e3b0c44298fc1c149afb...</content_hash>
      <evidence_grade>E2</evidence_grade>
      <evidence_type>prospective cohort</evidence_type>
      <AssocRefs>
        <!-- ref_label omitted when null (e.g., for kegg_disease) -->
        <ref type="mesh" id="D003967" label="Diarrhea"/>
        <ref type="kegg_disease" id="H00352"/>
      </AssocRefs>
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
