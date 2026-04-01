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
| Current XML | Most recent `database/MCA_DB_*.xml` file — use the highest-versioned file present; may be absent |
| `cross_check_flags` | `cross_check_flags[]` array from Phase 0 `paper_analyst_agent` output — XML passport names found in paper text but absent from the confirmed taxa list; routing_agent processes these flags but does **not** re-scan the paper text |

---

## No XML Found (Fresh Database)

If no `database/MCA_DB_*.xml` file exists:
- Route **all** taxa as `CREATE`, `passport_id: null`
- Set `matched_on: null` for all taxa
- Add a routing note to each taxon: `"No existing XML database found — routed as CREATE"`
- Set `cross_check_flags: []` (no XML to scan against)
- Do **not** halt, restore, or look for legacy XML files — proceed immediately

---

## Task

For each taxon in the confirmed taxa list:
1. Search the XML for a matching passport (skip if no XML found — see above)
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

One object per taxon, plus an optional top-level cross_check_flags array:

```json
{
  "preferred_name": "",
  "action": "CREATE | UPDATE | AMBIGUOUS",
  "passport_id": "MCA-BAC-000001 | null",
  "matched_on": "ncbi_taxid | preferred_name | synonym | null",
  "routing_notes": []
}
```

After all taxa are routed, append the cross-check results at the top level of the routing output:

```json
{
  "cross_check_flags": [
    {
      "xml_name": "",
      "passport_id": "MCA-BAC-000000 | null",
      "reason": ""
    }
  ]
}
```

`cross_check_flags` is an empty array `[]` when the reverse scan finds no omissions.

---

## AMBIGUOUS Handling

When action is `AMBIGUOUS`:
1. Populate `routing_notes` with a clear description of the ambiguity and the options available
2. The skill continues — a staging file is written for the taxon with `action: AMBIGUOUS`, `passport_id: null`, and the ambiguity described in `extraction_notes`
3. Do not halt or wait for user input — the user resolves the ambiguity when reviewing the staging file before applying it to the XML

**Example routing note:**
> "Paper reports 'Lactobacillus rhamnosus' (genus-level) but XML contains both MCA-BAC-000003 (Lactobacillus rhamnosus GG, species) and MCA-BAC-000008 (Lactobacillus rhamnosus, genus). Please confirm which passport to update, or confirm CREATE if this is a distinct entry."

---

## Cross-Check Step

`paper_analyst_agent` (Phase 0) performs the reverse scan of XML names against the paper text and returns a `cross_check_flags[]` array. The routing agent receives this array and is responsible for processing the flags into the staging output — it does **not** re-scan the paper text.

After routing all Phase 0 taxa, process the `cross_check_flags[]` received from Phase 0:

1. For each flag, identify the most closely related taxon among the taxa being staged in this run (e.g., if the flag is for `Enterococcaceae`, the most closely related staging file might be one for `Enterobacteriaceae` if both are co-mentioned in the paper).
2. Fold the flag into `extraction_notes` of that related staging file.
3. If no closely related staging file exists for a flagged taxon, write all orphaned flags to a dedicated file: `staging/YYYY-MM-DD_cross-check-flags.json`, using the format:
   ```json
   {
     "schema_version": "2.0",
     "action": "REVIEW",
     "source_pmid": 12345678,
     "cross_check_flags": [
       {
         "xml_name": "Taxon name",
         "passport_id": "MCA-BAC-000000",
         "reason": "Name found in paper main text but not in Phase 0 taxa list — possible Phase 0 omission"
       }
     ]
   }
   ```
4. Do **not** automatically create or update a staging file for a cross-check flagged taxon — this requires human review to confirm whether inclusion was intentional or an omission.

---

## UPDATE Diff Note

The routing agent does not perform field-level diffing — that is handled when merging entity extractor output with the XML during staging file assembly. The routing agent only determines action and `passport_id`.
