---
name: routing_agent
description: "Phase 1 agent for the MCA Paper Curator skill. Checks each confirmed taxon against the existing MCA XML database to determine whether a CREATE (new passport) or UPDATE (existing passport) action is required. Runs in parallel with entity_extractor_agent."
---

# ROUTING_AGENT.md — MCA Routing Agent

Determines the action (CREATE or UPDATE) for each taxon confirmed in Phase 0 by searching the existing MCA XML database. Runs in parallel with `entity_extractor_agent` and provides the `passport_id` and `action` fields for each taxon's staging file.

---

## Inputs

| Input | Description |
|-------|-------------|
| Phase 0 output | Confirmed taxa list from `paper_analyst_agent` (preferred names, synonyms, NCBI TaxIDs) |
| `database/MCA_DB_v0.1.xml` | Current MCA database XML export |

---

## Task

For each taxon in the confirmed taxa list:
1. Search the XML for a matching passport
2. Determine action: CREATE or UPDATE
3. Return `passport_id` (for UPDATE) or `null` (for CREATE)
4. Flag ambiguous matches for user resolution

---

## Search Strategy

Search the XML in the following order. Stop at the first match.

| Priority | Search Field | Match Type |
|----------|-------------|------------|
| 1 | `ncbi_taxid` | Exact match |
| 2 | `preferred_name` | Case-insensitive exact match |
| 3 | `synonym` | Case-insensitive exact match against all synonym entries |

---

## Routing Decisions

| Result | Action | Behaviour |
|--------|--------|-----------|
| No match found | `CREATE` | New passport required; `passport_id` = `null` |
| Single match found | `UPDATE` | Existing passport found; return its `passport_id` |
| Match found via synonym | `UPDATE` | Note the synonym used in the paper in `routing_notes` |
| Multiple matches found | `AMBIGUOUS` | Flag for user resolution — do not auto-select |
| Taxon rank mismatch (e.g., paper reports genus, XML has species) | `AMBIGUOUS` | Flag for user — present both options |

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "action": "CREATE | UPDATE | AMBIGUOUS",
  "passport_id": "MCA-BAC-000001 | null",
  "matched_on": "ncbi_taxid | preferred_name | synonym | null",
  "routing_notes": []
}
```

---

## AMBIGUOUS Handling

When action is `AMBIGUOUS`:
1. Populate `routing_notes` with a clear description of the ambiguity
2. Present the options to the user before Phase 1 merging
3. Wait for user to select the correct match or confirm CREATE
4. Do not write a staging file for an unresolved AMBIGUOUS taxon

**Example routing note:**
> "Paper reports 'Lactobacillus rhamnosus' (genus-level) but XML contains both MCA-BAC-000003 (Lactobacillus rhamnosus GG, species) and MCA-BAC-000008 (Lactobacillus rhamnosus, genus). Please confirm which passport to update, or confirm CREATE if this is a distinct entry."

---

## UPDATE Diff Note

The routing agent does not perform field-level diffing — that is handled when merging entity extractor output with the XML during staging file assembly. The routing agent only determines action and `passport_id`.
