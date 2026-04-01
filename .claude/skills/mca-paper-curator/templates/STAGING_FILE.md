# STAGING_FILE.md — Staging File Schema

Defines the JSON schema for staging files written by the MCA Paper Curator skill (`SKILL.md`). One file is produced per taxon per paper. The MCA XML Update Skill reads this schema to apply changes to `database/MCA_DB_vX.X.xml`.

**Location:** `staging/YYYY-MM-DD_[taxon-name-kebab-case].json`
**Example:** `staging/2026-03-31_clostridioides-difficile.json`

---

## Schema

```json
{
  "schema_version": "2.0",
  "action": "CREATE | UPDATE | AMBIGUOUS",
  "passport_id": "MCA-BAC-000001 | null",
  "last_reviewed": "YYYY-MM-DD",

  "source_paper": {
    "pmid": 12345678,
    "title": "",
    "authors": "",
    "journal": "",
    "year": "",
    "study_design": "",
    "population": "",
    "sample_size": null,
    "paper_summary": "2-3 sentence plain-language summary of the paper's key findings relevant to this taxon."
  },

  "evidence": {
    "grade": "E1 | E2 | E3 | UNCERTAIN",
    "rationale": "",
    "uncertain_reason": null
  },

  "proposed_changes": {

    "identity": {
      "preferred_name": "",
      "taxon_rank": "",
      "domain": "Bacteria | Archaea | Fungi | Virus | Eukaryote",
      "lineage": "",
      "ncbi_taxid": null,
      "synonyms": []
    },

    "biology": {
      "gram_status": "",
      "oxygen_tolerance": "",
      "morphology": "",
      "key_traits": [],
      "bacdive_url": ""
    },

    "ecology": {
      "primary_niches": [
        {"value": "", "mesh_anatomy_id": null}
      ],
      "reservoirs": [],
      "transmission_routes": []
    },

    "clinical_profile": {
      "is_pathobiont": "yes | no | context dependent | unknown",
      "clinical_roles": [],
      "typical_specimens": [
        {"value": "", "mesh_anatomy_id": null}
      ],
      "bloom_triggers": [
        {"value": "", "kegg_drug_id": null}
      ],
      "risk_contexts": [],
      "amr_highlights": [
        {"value": "", "aro_id": null}
      ]
    },

    "metabolites": [
      {
        "metabolite_name": "",
        "relationship": "produces | consumes | modifies",
        "kegg_compound_id": null,
        "chebi_id": null
      }
    ],

    "clinical_associations": [
      {
        "association_text": "",
        "evidence_level": "E1 | E2 | E3 | UNCERTAIN",
        "evidence_type": "",
        "assoc_refs": [
          {"ref_type": "mesh", "ref_id": "", "ref_label": null},
          {"ref_type": "kegg_disease", "ref_id": "", "ref_label": null}
        ],
        "pmids": []
      }
    ],

    "taxon_level_pmids": []
  },

  "extraction_notes": []
}
```

---

## Field Notes

### `source_paper.pmid`
Integer, not string. Use `null` if PMID is unavailable.

### `identity.ncbi_taxid`
Integer, not string. Use `null` if not determinable.

### `identity.domain`
Required on CREATE. Derived from the first element of `lineage`. Must be one of: `Bacteria`, `Archaea`, `Fungi`, `Virus`, `Eukaryote`.

### `taxon_level_pmids` and `assoc_refs[].pmids`
Arrays of integers, not strings.

### Ext-ID fields (`mesh_anatomy_id`, `kegg_drug_id`, `aro_id`, `kegg_compound_id`, `chebi_id`, `ref_id`)
All nullable. Populate during curation if the ID is known; leave `null` if not. Ontology enrichment is progressive — a `null` is not an error.

### `assoc_refs`
One entry per external ID linked to the association. Use `[]` if none are known. `ref_label` is the human-readable name (e.g., MeSH preferred term); omit or set to `null` for KEGG Disease IDs.

### `metabolites`
Use `[]` if no metabolite data is present in the paper. Each entry requires at minimum `metabolite_name` and `relationship`; the ID fields are optional.

### `source_paper.paper_summary`
Write 2–3 sentences covering the paper's key findings **as they relate specifically to this taxon**. When the same paper generates multiple staging files, each summary must be independently meaningful for its taxon — do not copy-paste the same summary across files. Include: study type and population, the taxon's primary role or finding in this paper, and any key caveats specific to this taxon's evidence.

### `clinical_associations[].association_text`
Write a single self-contained sentence (two sentences maximum) that states: the taxon, the clinical finding or outcome, the direction and magnitude if reported (e.g., OR, p-value, correlation), and the study context. Paraphrase — do not quote verbatim. Include statistics if reported. Do not merge multiple distinct findings into one block; use separate association objects instead.

### `evidence_type`
The study design that generated this specific association — typically matches `source_paper.study_design` for single-design papers (e.g., `"prospective cohort"`, `"RCT"`, `"systematic review"`).

---

## Field Rules

| Field | CREATE | UPDATE |
|-------|--------|--------|
| `action` | `"CREATE"` | `"UPDATE"` |
| `passport_id` | `null` *(assigned on import)* | Existing ID from XML |
| `identity.domain` | Required | Omit if unchanged |
| `proposed_changes.*` | All extractable fields populated | Only fields that differ from existing XML; omit unchanged fields |
| `extraction_notes` | Any ambiguities or flags from extraction | Same |

---

## Null and Empty Values

- Use `null` for scalar fields the paper does not report
- Use `[]` for empty lists
- For object-array fields (`primary_niches`, `typical_specimens`, `bloom_triggers`, `amr_highlights`, `metabolites`): use `[]` when empty — do not include objects with all-null values
- `uncertain_reason` is `null` when grade is not `UNCERTAIN`

---

## UPDATE Diff Behaviour

For UPDATE actions, `proposed_changes` contains only the delta — fields and values to be added or modified. Fields absent from `proposed_changes` are left untouched in the XML.

- **List fields** (`clinical_associations`, `synonyms`, `primary_niches`, etc.): values are appended, not replaced
- **Scalar fields** (`gram_status`, `is_pathobiont`, etc.): new value replaces existing — flag in `extraction_notes` if overwriting a non-null value

---

## Validation Checklist (before staging file is written)

- [ ] `schema_version` is `"2.0"`
- [ ] `action` is `CREATE`, `UPDATE`, or `AMBIGUOUS`
- [ ] `passport_id` is null for CREATE, valid ID for UPDATE
- [ ] `last_reviewed` is a valid `YYYY-MM-DD` date
- [ ] `evidence.grade` is one of `E1`, `E2`, `E3`, `UNCERTAIN`
- [ ] `identity.domain` is present for CREATE
- [ ] `source_paper.pmid` and `taxon_level_pmids` are integers (not strings)
- [ ] All field values conform to `references/CONTROLLED_VOCABULARY.md`
- [ ] Every clinical association has `evidence_type` populated
- [ ] Every clinical association has at least one PMID
- [ ] `evidence.uncertain_reason` is populated when grade is `UNCERTAIN`
- [ ] `extraction_notes` documents any flags or unmapped terms
