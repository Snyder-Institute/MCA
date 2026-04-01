---
name: kegg_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Maps extracted entity terms to KEGG IDs using the local KEGG mirror flat files: clinical association conditions → KEGG Disease (H numbers); bloom trigger drug names → KEGG Drug (D numbers); metabolite names → KEGG Compound (C numbers). Runs in parallel with mesh_agent and aro_agent."
---

# KEGG_AGENT.md — MCA KEGG Enrichment Agent

Maps extracted entity names to KEGG identifiers using the local KEGG flat file mirror. Handles three entity types in one pass: clinical conditions (KEGG Disease), drugs and antibiotics (KEGG Drug), and metabolites (KEGG Compound). Returns enriched data for staging file assembly.

**Local KEGG mirror path:** See project memory (`reference_kegg_path.md`) — do not hardcode in this file.

---

## Inputs

| Input | Description |
|-------|-------------|
| `entity_extractor output` | Full output from `entity_extractor_agent` — specifically `clinical_associations[]`, `clinical_profile.bloom_triggers[]`, `metabolites[]` |
| `kegg_mirror_path` | Absolute path to the local KEGG flat file mirror — resolved by the orchestrator from project memory (`reference_kegg_path.md`) before this agent is called. The orchestrator must pass this path explicitly; the agent does not access memory directly. |

---

## Flat Files Used

Construct full paths by joining `kegg_mirror_path` (from Inputs) with the relative paths below. All files are pre-extracted plain text — no decompression needed. Read them directly using the Read or Grep tool.

| KEGG resource | Path relative to `kegg_mirror_path` | Entry prefix | Encoding |
|---|---|---|---|
| KEGG Disease | `medicus/disease/disease` | `H` | English |
| KEGG Drug | `medicus/drug/drug` | `D` | Mixed JP/EN — English names present as USP/INN names |
| KEGG Compound | `ligand/compound/compound` | `C` | English |

Entries in all three files are delimited by `///` on its own line.

---

## Flat File Format

All three files follow the same KEGG flat file format. Entries are separated by `///`.

**Disease entry structure:**
```
ENTRY       H00001                      Disease
NAME        Prostate cancer
DESCRIPTION ...
CATEGORY    Cancer
///
```

**Drug entry structure (mixed JP/EN — English names are the USP/INN names):**
```
エントリ        D00645                      Drug
一般名         アンピシリン (JP18);
            Ampicillin (USP/INN);
            Anhydrous ampicillin (JP18)
...
///
```
Extract English drug names from lines containing `(USP)`, `(INN)`, `(BP)`, `(USAN)` — these are always ASCII and unambiguously English.

**Compound entry structure:**
```
ENTRY       C00246                      Compound
NAME        Butanoic acid;
            Butyric acid;
            Butyrate
FORMULA     C4H8O2
...
///
```

---

## Task

### Task 1 — Build lookup indexes

Read and parse all three flat files on startup. Build three in-memory indexes:

```
disease_index:  {lowercase_name → H_id, ...}   (all NAME aliases)
drug_index:     {lowercase_name → D_id, ...}    (English names only — USP/INN/BP lines)
compound_index: {lowercase_name → C_id, ...}    (all NAME aliases)
```

Each `NAME` field can have multiple aliases (semicolon or newline-separated). Index all aliases for each entry.

Parsing steps per file:
1. Split on `///`
2. For each entry: extract the ID from the `ENTRY` line (first token of the value after whitespace — e.g., `H00001`, `D00645`, `C00246`)
3. Extract all name aliases from `NAME` lines (and continuation lines, which are indented)
4. For Drug: only index lines that contain `(USP)`, `(INN)`, `(BP)`, `(USAN)`, `(JAN)` — these are the English names

---

### Task 2 — Map clinical association conditions to KEGG Disease

For each clinical association in `clinical_associations[]`:
1. From the `association_text`, identify the primary disease, syndrome, or clinical condition being described. This is the condition the taxon is being linked to (not the taxon itself, not the study population).
   - Example: *"C. difficile infection is the leading cause of healthcare-associated diarrhoea"* → condition: `Clostridioides difficile infection`
   - Example: *"Reduced Akkermansia abundance is associated with type 2 diabetes"* → condition: `type 2 diabetes`
2. Attempt exact match (case-insensitive) against `disease_index`.
3. If no exact match: attempt partial match — find entries where the condition name is a substring of an indexed disease name, or vice versa.
4. If multiple matches: select the most specific / best-fitting match. Record in `kegg_notes` if ambiguous.
5. If no match found: leave `kegg_disease_id` as null. Do not force a match.

---

### Task 3 — Map bloom trigger drugs to KEGG Drug

For each bloom trigger in `bloom_triggers[]`:
1. Take the `value` field (e.g., `"antibiotic exposure"`, `"proton pump inhibitor (PPI) use"`)
2. Extract the drug or drug class name from the value (strip context words like "exposure", "use", "therapy")
3. Attempt exact → partial match against `drug_index`
4. If the value is a drug class rather than a specific drug (e.g., `"antibiotic exposure"`), do not attempt lookup — leave `kegg_drug_id` as null and note in `kegg_notes`. KEGG Drug contains individual drugs, not classes.
5. If a specific drug is named (e.g., `"proton pump inhibitor (PPI) use"` → `"omeprazole"` if extractable, or `"vancomycin"`) → look up and assign.

---

### Task 4 — Map metabolite names to KEGG Compound

For each metabolite in `metabolites[]`:
1. Take the `metabolite_name` field (e.g., `"butyric acid"`, `"TMAO"`, `"short-chain fatty acids"`)
2. Attempt exact → partial match against `compound_index`
3. Drug class terms (`"SCFAs"`, `"bile acids"`) will not have compound entries — leave `kegg_compound_id` as null
4. Specific compounds (`"butyrate"`, `"acetate"`, `"trimethylamine N-oxide"`) should have matches
5. If no match: leave null; note in `kegg_notes`

---

## Matching Strategy

| Step | Match type | Rule |
|------|-----------|------|
| 1 | Exact | Full string match (case-insensitive, stripped of trailing punctuation) |
| 2 | Alias | Query matches any alias in the indexed entry |
| 3 | Substring | Indexed name contains query OR query contains indexed name |
| 4 | Abbreviation | Match known abbreviations: CDI → "Clostridioides difficile infections"; T2D/T2DM → "Type 2 diabetes"; IBD → "Inflammatory bowel disease"; CRC → "Colorectal cancer" |
| — | No match | Return null; do not fabricate IDs |

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "clinical_associations": [
      {
        "association_text": "",
        "assoc_refs": [
          {"ref_type": "kegg_disease", "ref_id": "H00282", "ref_label": null}
        ]
      }
    ],
    "bloom_triggers": [
      {"value": "antibiotic exposure", "kegg_drug_id": null},
      {"value": "vancomycin", "kegg_drug_id": "D00052"}
    ],
    "metabolites": [
      {"metabolite_name": "butyric acid", "kegg_compound_id": "C00246"},
      {"metabolite_name": "short-chain fatty acids", "kegg_compound_id": null}
    ]
  },
  "kegg_notes": []
}
```

- `clinical_associations` list order must match the entity extractor order.
- `assoc_refs` contains only `ref_type: "kegg_disease"` entries — MeSH terms are added by `mesh_agent`.
- `ref_label` is always `null` for KEGG Disease — the ID is sufficient.
- Omit a field from `enriched_fields` entirely if no IDs were resolved for it.
- Populate `kegg_notes` when: no match found for a term, ambiguous match chosen, drug class term skipped, file read error encountered.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return KEGG IDs confirmed by the flat file index. Never guess or invent IDs. |
| Null on miss | If no match is found, return `null` — not the nearest approximate. |
| Drug classes | Do not attempt KEGG Drug lookup for general drug class terms — only specific drug names. |
| File not found | If a flat file cannot be read (path wrong, file missing), this is a technical blocker — halt and interrupt the user per Skill v3.1 Checkpoint Rule 7. Do not silently skip. |
| Length preservation | Return exactly as many association objects as the entity extractor output — one per association, in the same order. Never skip an association with no KEGG match; return it with `assoc_refs: []`. |
| Order preservation | Return association objects in the same order as entity extractor output. |
| Non-blocking | Lookup failures do not halt the skill — all errors go to `kegg_notes`. |
