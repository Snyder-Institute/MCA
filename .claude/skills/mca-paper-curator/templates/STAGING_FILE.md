# STAGING_FILE.md — Staging File Schema

Defines the JSON schema for staging files written by the MCA Paper Curator skill (`SKILL.md`). One file is produced per taxon per paper. The MCA XML Update Skill (Skill 2) reads this schema to apply changes to `database/MCA_DB_vX.X.xml`.

**Location:** `staging/YYYY-MM-DD_[taxon-name-kebab-case].json`
**Example:** `staging/2026-03-31_clostridioides-difficile.json`

---

## Schema

```json
{
  "schema_version": "1.0",
  "action": "CREATE | UPDATE",
  "passport_id": "MCA-BAC-000001 | null",
  "last_reviewed": "YYYY-MM-DD",

  "source_paper": {
    "pmid": "12345678 | null",
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
    "uncertain_reason": "null | explanation if UNCERTAIN"
  },

  "proposed_changes": {

    "identity": {
      "preferred_name": "",
      "taxon_rank": "",
      "lineage": "",
      "ncbi_taxid": "",
      "synonyms": []
    },

    "biology": {
      "gram_status": "",
      "oxygen_tolerance": "",
      "morphology": "",
      "key_traits": []
    },

    "ecology": {
      "primary_niches": [],
      "reservoirs": [],
      "transmission_routes": []
    },

    "clinical_profile": {
      "is_pathobiont": "yes | no | context dependent | unknown",
      "clinical_roles": [],
      "typical_specimens": [],
      "bloom_triggers": [],
      "risk_contexts": [],
      "amr_highlights": []
    },

    "clinical_associations": [
      {
        "association_text": "",
        "evidence_grade": "E1 | E2 | E3 | UNCERTAIN",
        "pmids": []
      }
    ],

    "taxon_level_pmids": []
  },

  "extraction_notes": []
}
```

---

## Field Rules

| Field | CREATE | UPDATE |
|-------|--------|--------|
| `action` | `"CREATE"` | `"UPDATE"` |
| `passport_id` | `null` *(assigned on import)* | Existing ID from XML |
| `proposed_changes.*` | All extractable fields populated | Only fields that differ from existing XML; omit unchanged fields |
| `extraction_notes` | Any ambiguities or flags from extraction | Same |

---

## Null and Empty Values

- Use `null` for fields the paper does not report (do not use `""` or `"unknown"` unless `unknown` is a valid controlled vocabulary term for that field)
- Use `[]` for empty lists
- `uncertain_reason` is `null` when grade is not `UNCERTAIN`

---

## UPDATE Diff Behaviour

For UPDATE actions, `proposed_changes` contains only the delta — fields and values to be added or modified. Fields absent from `proposed_changes` are left untouched in the XML.

- **List fields** (e.g., `clinical_associations`, `synonyms`): values are appended, not replaced
- **Scalar fields** (e.g., `gram_status`, `is_pathobiont`): new value replaces existing — flag in `extraction_notes` if overwriting a non-null value

---

## Validation Checklist (before staging file is written)

- [ ] `action` is `CREATE` or `UPDATE`
- [ ] `passport_id` is null for CREATE, valid ID for UPDATE
- [ ] `last_reviewed` is a valid `YYYY-MM-DD` date
- [ ] `evidence.grade` is one of `E1`, `E2`, `E3`, `UNCERTAIN`
- [ ] All field values conform to `references/CONTROLLED_VOCABULARY.md`
- [ ] Every clinical association has at least one PMID
- [ ] `evidence.uncertain_reason` is populated when grade is `UNCERTAIN`
- [ ] `extraction_notes` documents any flags or unmapped terms
