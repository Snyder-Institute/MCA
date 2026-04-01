---
name: xsd_writer_agent
description: "Bootstrap agent for the mca-xml-update skill. Reads MCA_create_database.sql and xml2sql.py to derive the authoritative XML structure, then writes two files: (1) database/MCA_schema.xsd — a formal XML Schema Definition, and (2) a skeleton database/MCA_DB_v0_1_YYYYMMDD.xml — an empty-but-valid XML snapshot ready for xml_writer_agent. Invoked by the orchestrator only when no MCA_DB_v*.xml file exists in the database/ directory."
---

# XSD Writer Agent — MCA Bootstrap

Bootstraps the MCA XML layer from scratch. Reads the relational schema (`MCA_create_database.sql`) and the SQL↔XML mapping (`xml2sql.py`) to derive the authoritative XML structure, then writes:

1. **`database/MCA_schema.xsd`** — an XML Schema Definition that formally constrains MCA XML files
2. **`database/MCA_DB_v0_1_YYYYMMDD.xml`** — a skeleton XML snapshot (empty passports, correct structure) that `xml_writer_agent` can use as its `source_xml_path`

> **Invoked by:** the mca-xml-update orchestrator, only when `glob database/MCA_DB_v*.xml` returns no results.
> **Never invoked directly by the user.**

---

## Inputs (provided by orchestrator)

| Input | Description |
|-------|-------------|
| `output_version_string` | Version string for the skeleton XML, e.g. `v0_1_20260401` — always starts at `v0_1` for a fresh database |
| `output_xml_path` | Absolute path for the skeleton XML, e.g. `database/MCA_DB_v0_1_20260401.xml` |
| `output_xsd_path` | Absolute path for the XSD file — always `database/MCA_schema.xsd` |

---

## Outputs (returned to orchestrator)

```json
{
  "status": "success | error",
  "output_xml_path": "database/MCA_DB_v0_1_20260401.xml",
  "output_xsd_path": "database/MCA_schema.xsd",
  "error": null
}
```

---

## Execution Steps

### Step 1 — Read schema sources

Read the following files to derive the authoritative XML structure:

1. **`database/xml2sql.py`** — The authoritative SQL↔XML mapping. The `TAG_SPECS` list defines all tag-based fields (synonyms, key_traits, niches, specimens, triggers, AMR, roles, reservoirs, transmission_routes, risk_contexts) and their ext-ID attributes. The `main()` function defines the full XML XPath structure for every table.

2. **`database/MCA_create_database.sql`** — The relational schema (plain SQL, not compressed). Extract column names, data types, and constraints for each table. Focus on:
   - `passport` table — core passport fields and types
   - `biology` table — biology scalar fields
   - `taxon_tag` table — tag categories and ext_id
   - `metabolite` table — metabolite fields
   - `association` table — `evidence_level` ENUM values (used in XSD restriction)
   - `assoc_ref` table — `ref_type` values
   - `paper` table — paper metadata fields

3. **`agents/XML_WRITER_AGENT.md`** (this skill's own file) — The XML element structure reference. Use the "XML Structure Reference" section to confirm element naming, nesting, and attribute names.

If `MCA_create_database.sql` cannot be read, derive field types from `xml2sql.py` alone and note the limitation in a comment at the top of the XSD.

---

### Step 2 — Generate the XSD

Write `database/MCA_schema.xsd` with the following structure. Use the sources from Step 1 to fill in accurate type restrictions (ENUMs, string patterns, integer types).

#### 2.1 — XSD skeleton

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           elementFormDefault="qualified"
           attributeFormDefault="unqualified">

  <!-- ── Root ─────────────────────────────────────────────────────────── -->
  <xs:element name="MicrobialClinicalAtlas">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Meta"          type="MetaType"/>
        <xs:element name="Papers"        type="PapersType"  minOccurs="0"/>
        <xs:element name="TaxonPassport" type="TaxonPassportType"
                    minOccurs="0" maxOccurs="unbounded"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>

  <!-- ── Meta ──────────────────────────────────────────────────────────── -->
  <xs:complexType name="MetaType">
    <xs:sequence>
      <xs:element name="version" type="xs:string"/>
      <xs:element name="created" type="xs:date" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <!-- ── Papers ────────────────────────────────────────────────────────── -->
  <xs:complexType name="PapersType">
    <xs:sequence>
      <xs:element name="Paper" type="PaperType" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="PaperType">
    <xs:sequence>
      <xs:element name="pmid"         type="xs:positiveInteger"/>
      <xs:element name="title"        type="xs:string"          minOccurs="0"/>
      <xs:element name="authors"      type="xs:string"          minOccurs="0"/>
      <xs:element name="journal"      type="xs:string"          minOccurs="0"/>
      <xs:element name="year"         type="xs:gYear"           minOccurs="0"/>
      <xs:element name="study_design" type="xs:string"          minOccurs="0"/>
      <xs:element name="population"   type="xs:string"          minOccurs="0"/>
      <xs:element name="sample_size"  type="xs:positiveInteger" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <!-- ── TaxonPassport ─────────────────────────────────────────────────── -->
  <xs:complexType name="TaxonPassportType">
    <xs:sequence>
      <!-- Core identity fields (always present) -->
      <xs:element name="passport_id"   type="PassportIdType"/>
      <xs:element name="preferred_name" type="xs:string"/>
      <xs:element name="taxon_rank"    type="TaxonRankType"/>
      <xs:element name="domain"        type="DomainType"/>
      <xs:element name="lineage"       type="xs:string"/>
      <xs:element name="ncbi_taxid"    type="xs:positiveInteger"/>
      <xs:element name="is_pathobiont" type="PathobiontType"/>
      <xs:element name="last_reviewed" type="xs:date"/>
      <xs:element name="created_at"    type="xs:date"/>
      <xs:element name="updated_at"    type="xs:date"/>
      <!-- Satellite blocks (optional) -->
      <xs:element name="Synonyms"             type="SynonymsType"          minOccurs="0"/>
      <xs:element name="Biology"              type="BiologyType"           minOccurs="0"/>
      <xs:element name="Ecology"              type="EcologyType"           minOccurs="0"/>
      <xs:element name="ClinicalProfile"      type="ClinicalProfileType"   minOccurs="0"/>
      <xs:element name="Metabolites"          type="MetabolitesType"       minOccurs="0"/>
      <xs:element name="TaxonEvidencePmids"   type="PmidListType"          minOccurs="0"/>
      <xs:element name="ClinicalAssociations" type="ClinicalAssociationsType" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <!-- ── Controlled-vocabulary simple types ────────────────────────────── -->

  <!-- passport_id format: MCA-BAC-000001 / MCA-FUN-000001 etc. -->
  <xs:simpleType name="PassportIdType">
    <xs:restriction base="xs:string">
      <xs:pattern value="MCA-(BAC|FUN|VIR|ARC)-[0-9]{6}"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="TaxonRankType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="domain"/>
      <xs:enumeration value="phylum"/>
      <xs:enumeration value="class"/>
      <xs:enumeration value="order"/>
      <xs:enumeration value="family"/>
      <xs:enumeration value="genus"/>
      <xs:enumeration value="species"/>
      <xs:enumeration value="subspecies"/>
      <xs:enumeration value="strain"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="DomainType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="Bacteria"/>
      <xs:enumeration value="Fungi"/>
      <xs:enumeration value="Viruses"/>
      <xs:enumeration value="Archaea"/>
    </xs:restriction>
  </xs:simpleType>

  <xs:simpleType name="PathobiontType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="yes"/>
      <xs:enumeration value="no"/>
      <xs:enumeration value="context dependent"/>
      <xs:enumeration value="unknown"/>
    </xs:restriction>
  </xs:simpleType>

  <!-- evidence_level values must match the SQL ENUM in the association table -->
  <xs:simpleType name="EvidenceLevelType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="E1"/>
      <xs:enumeration value="E2"/>
      <xs:enumeration value="E3"/>
      <!-- UNCERTAIN is valid in staging files but skipped by xml2sql.py -->
      <xs:enumeration value="UNCERTAIN"/>
    </xs:restriction>
  </xs:simpleType>

  <!-- ── Satellite blocks ──────────────────────────────────────────────── -->

  <xs:complexType name="SynonymsType">
    <xs:sequence>
      <xs:element name="synonym" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="BiologyType">
    <xs:sequence>
      <xs:element name="gram_status"       type="xs:string" minOccurs="0"/>
      <xs:element name="oxygen_tolerance"  type="xs:string" minOccurs="0"/>
      <xs:element name="morphology"        type="xs:string" minOccurs="0"/>
      <xs:element name="KeyTraits"         type="KeyTraitsType" minOccurs="0"/>
      <xs:element name="bacdive_url"       type="xs:anyURI" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="KeyTraitsType">
    <xs:sequence>
      <xs:element name="key_trait" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="EcologyType">
    <xs:sequence>
      <xs:element name="PrimaryNiches"     type="PrimaryNichesType"     minOccurs="0"/>
      <xs:element name="Reservoirs"        type="ReservoirsType"        minOccurs="0"/>
      <xs:element name="TransmissionRoutes" type="TransmissionRoutesType" minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="PrimaryNichesType">
    <xs:sequence>
      <xs:element name="primary_niche" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:string">
              <xs:attribute name="mesh_anatomy_id" type="xs:string" use="optional"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="ReservoirsType">
    <xs:sequence>
      <xs:element name="reservoir" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="TransmissionRoutesType">
    <xs:sequence>
      <xs:element name="transmission_route" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="ClinicalProfileType">
    <xs:sequence>
      <xs:element name="ClinicalRoles"    type="ClinicalRolesType"    minOccurs="0"/>
      <xs:element name="TypicalSpecimens" type="TypicalSpecimensType" minOccurs="0"/>
      <xs:element name="BloomTriggers"    type="BloomTriggersType"    minOccurs="0"/>
      <xs:element name="RiskContexts"     type="RiskContextsType"     minOccurs="0"/>
      <xs:element name="AmrHighlights"    type="AmrHighlightsType"    minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="ClinicalRolesType">
    <xs:sequence>
      <xs:element name="clinical_role" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="TypicalSpecimensType">
    <xs:sequence>
      <xs:element name="typical_specimen" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:string">
              <xs:attribute name="mesh_anatomy_id" type="xs:string" use="optional"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="BloomTriggersType">
    <xs:sequence>
      <xs:element name="bloom_trigger" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:string">
              <xs:attribute name="kegg_drug_id" type="xs:string" use="optional"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="RiskContextsType">
    <xs:sequence>
      <xs:element name="risk_context" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="AmrHighlightsType">
    <xs:sequence>
      <xs:element name="amr_highlight" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:string">
              <xs:attribute name="aro_id" type="xs:string" use="optional"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="MetabolitesType">
    <xs:sequence>
      <xs:element name="Metabolite" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="metabolite_name"   type="xs:string"/>
            <xs:element name="relationship"      type="xs:string" minOccurs="0"/>
            <xs:element name="kegg_compound_id"  type="xs:string" minOccurs="0"/>
            <xs:element name="chebi_id"          type="xs:string" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="PmidListType">
    <xs:sequence>
      <xs:element name="pmid" type="xs:positiveInteger" minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="ClinicalAssociationsType">
    <xs:sequence>
      <xs:element name="ClinicalAssociation" type="ClinicalAssociationType"
                  minOccurs="0" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="ClinicalAssociationType">
    <xs:sequence>
      <xs:element name="association_text" type="xs:string"/>
      <xs:element name="content_hash"    type="xs:string" minOccurs="0"/>
      <xs:element name="evidence_level"  type="EvidenceLevelType"/>
      <xs:element name="evidence_type"   type="xs:string"          minOccurs="0"/>
      <xs:element name="AssocRefs"       type="AssocRefsType"      minOccurs="0"/>
      <xs:element name="Pmids"           type="PmidListType"       minOccurs="0"/>
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="AssocRefsType">
    <xs:sequence>
      <xs:element name="ref" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:attribute name="type"  type="xs:string" use="required"/>
          <xs:attribute name="id"    type="xs:string" use="required"/>
          <xs:attribute name="label" type="xs:string" use="optional"/>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>

</xs:schema>
```

#### 2.2 — Schema reconciliation rules

After deriving the XSD skeleton above, reconcile it against the SQL schema:

- For each column in the SQL `association` table with a `ENUM(...)` definition, verify the `EvidenceLevelType` enumeration values match exactly.
- For `passport.is_pathobiont` ENUM: verify `PathobiontType` values match.
- For `passport.taxon_rank` ENUM: verify `TaxonRankType` values match.
- If the SQL defines additional columns not reflected in the XSD, add them as `minOccurs="0"` elements with the appropriate XSD type and note the addition in a comment.
- If the SQL ENUM has values that conflict with `.claude/skills/mca-paper-curator/references/CONTROLLED_VOCABULARY.md`, note the discrepancy as an XSD comment — do not silently resolve it.

---

### Step 3 — Generate the skeleton XML

Write `database/MCA_DB_[output_version_string].xml` as an empty-but-valid XML snapshot:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<MicrobialClinicalAtlas>
 <Meta>
  <version>[output_version_string]</version>
  <created>[YYYY-MM-DD]</created>
 </Meta>
 <Papers>
 </Papers>
</MicrobialClinicalAtlas>
```

Rules:
- `[output_version_string]` is the value passed in by the orchestrator (e.g., `v0_1_20260401`)
- `[YYYY-MM-DD]` is today's date
- No `<TaxonPassport>` elements — this is the empty starting point
- 1-space indentation throughout
- The file must be valid against the XSD written in Step 2

---

### Step 4 — Return report

```json
{
  "status": "success",
  "output_xml_path": "database/MCA_DB_v0_1_20260401.xml",
  "output_xsd_path": "database/MCA_schema.xsd",
  "error": null
}
```

If either file cannot be written, return `status: "error"` with a descriptive `error` message. The orchestrator will halt and report the error to the user.

---

## Error Handling

| Error | Behaviour |
|-------|-----------|
| `MCA_create_database.sql.gz` not found or unreadable | Proceed using `xml2sql.py` alone; add comment to XSD header noting SQL file was unavailable |
| SQL ENUM conflict with `.claude/skills/mca-paper-curator/references/CONTROLLED_VOCABULARY.md` | Write XSD with a `<!-- CONFLICT: ... -->` comment; do not halt |
| `output_xml_path` already exists | Return `status: "error"` — orchestrator should not call this agent if a file already exists |
| `output_xsd_path` already exists | Overwrite — XSD is always regenerated to reflect the current schema |
| File write failure | Return `status: "error"` with OS error message |

---

## Invocation Context

The orchestrator calls this agent only when the "locate most recent XML" step in Phase 2 returns no results:

```
glob database/MCA_DB_v*.xml → [] (empty)
  → invoke xsd_writer_agent:
      output_version_string = "v0_1_YYYYMMDD"
      output_xml_path       = "database/MCA_DB_v0_1_YYYYMMDD.xml"
      output_xsd_path       = "database/MCA_schema.xsd"
  → use output_xml_path as source_xml_path for subsequent xml_writer_agent calls
```

After `xsd_writer_agent` succeeds, MAJOR=0, MINOR=1 are read from the generated filename, and the orchestrator determines `output_xml_path` for the session (which will equal `source_xml_path` for a same-day bootstrap — the usual same-day update-in-place rule applies).
