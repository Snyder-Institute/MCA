---
name: aro_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Maps extracted AMR phenotype names (ESBL, CRE, MRSA, VRE, etc.) to CARD Antibiotic Resistance Ontology (ARO) identifiers using the full ARO OBO ontology file. Runs in parallel with mesh_agent and kegg_agent."
---

# ARO_AGENT.md — MCA CARD/ARO Enrichment Agent

Maps Antimicrobial Resistance (AMR) phenotype names extracted by `entity_extractor_agent` to stable ARO identifiers from the Comprehensive Antibiotic Resistance Database (CARD). Returns enriched AMR highlight objects with `aro_id` populated where a confident match is found.

**CARD database:** [card.mcmaster.ca](https://card.mcmaster.ca) — maintained by McMaster University.  
**ARO format:** `ARO:NNNNNNN` (e.g., `ARO:3004305`)

---

## Background

CARD's Antibiotic Resistance Ontology (ARO) is the standard controlled vocabulary for AMR mechanisms, genes, and phenotypes. Each ARO term has:
- A stable identifier: `ARO:NNNNNNN`
- A preferred name (e.g., `multidrug resistance antimicrobial phenotype`)
- Synonyms and related terms
- Links to resistance mechanisms, affected drug classes, and organism associations

MCA uses ARO IDs on `amr_highlights` to make resistance phenotypes machine-readable and cross-database queryable.

**Important ARO coverage caveat:** ARO covers *acquired* resistance mechanisms, gene families, and clinical phenotype labels for known pathogens (MRSA, VRE, MDR, etc.). It does **not** have terms for:
- Intrinsic structural resistance in commensal organisms (e.g., intrinsic glycopeptide/vancomycin insensitivity due to natural D-Ala-D-Lac peptidoglycan in Akkermansia, Bifidobacterium, Lactobacillales). These organisms are simply not targets of glycopeptides — there is no acquired Van gene or resistance mechanism.
- Sentinel values (`none documented`, `unknown`).
Always return `null` for these cases.

---

## Inputs

| Input | Description |
|-------|-------------|
| `entity_extractor output` | `clinical_profile.amr_highlights[]` — list of `{value, aro_id: null}` objects |

---

## Data Source

**Primary source — local ARO JSON index (pre-built):**

A pre-built JSON index is available at the path recorded in project memory (`reference_aro_path.md`). The orchestrator resolves this path and passes it to this agent before it runs.

```
aro_index.json  →  {aro_id → {name: str, synonyms: [str, ...]}}
```

8,564 terms, built from `aro.obo` on 2026-04-02. Load the JSON file directly — no web fetch required.

**Fallback — ARO OBO file from OBO Foundry:**

If the local index file is missing, fall back to:
```
WebFetch https://purl.obolibrary.org/obo/aro.obo
```
The OBO file contains all ARO terms including phenotype-level terms (e.g., `multidrug resistance antimicrobial phenotype`, `vancomycin-resistant Enterococcus`) that are **absent from CARD's `card.json`**.

**Do NOT use `card.json` for phenotype lookup** — `card.json` (from `card.mcmaster.ca/latest/data`) contains gene model entries only (resistance genes, proteins, variants). It does not include AMR phenotype terms like `ARO:3004305`. The CARD website is also JavaScript-rendered and cannot be scraped.

**OBO file format** — entries are `[Term]` blocks:
```
[Term]
id: ARO:3004305
name: multidrug resistance antimicrobial phenotype
def: "Multidrug-resistant organisms are defined as..." [PMID:...]
synonym: "MDRO" EXACT []
is_a: ARO:3000700 ! resistant antimicrobial phenotype
```
Parse `id:`, `name:`, and `synonym:` lines per `[Term]` block to build the lookup index.

---

## Task

### Task 1 — Build ARO lookup index

1. Load the local `aro_index.json` (path passed by orchestrator from project memory `reference_aro_path.md`).
   - Format: `{aro_id → {name: str, synonyms: [str, ...]}}`
   - 8,564 terms
2. Build an in-memory name lookup:
   ```
   aro_lookup: {lowercase_name → aro_id, ...}
   ```
   Index the preferred `name` and all `synonyms` values (already plain strings — no suffix stripping needed).
3. If local file is missing: fall back to `WebFetch https://purl.obolibrary.org/obo/aro.obo`, parse OBO format (split on `[Term]`, extract `id:`, `name:`, `synonym:` fields). Log the fallback in `aro_notes`.
4. If both fail: proceed to confirmed mapping table (Task 2) and return `null` for all unconfirmed terms. Log in `aro_notes`. Do not halt.

### Task 2 — Map AMR phenotype names to ARO IDs

For each AMR highlight in `amr_highlights[]`:

1. **Apply skip rules first** (return `null` immediately without lookup):
   - Value is `"none documented"` or `"unknown"` → `null`
   - Value contains `"intrinsic glycopeptide resistance"`, `"intrinsic vancomycin resistance"`, or similar intrinsic structural resistance phrasing in a commensal context → `null` (no ARO phenotype term exists; see Background section)

2. Take the `value` field (e.g., `"ESBL-producing"`, `"CRE"`, `"multidrug-resistant (MDR)"`)

3. Normalise: strip qualifier words (`-producing`, `-resistant`, `documented`, `strains`, parenthetical expansions, etc.) to extract the core phenotype term

4. Apply confirmed mappings first (skip lookup if a match is found here):

| MCA value | Confirmed ARO ID | ARO preferred name |
|-----------|------------------|--------------------|
| `multidrug-resistant (MDR)` | `ARO:3004305` | multidrug resistance antimicrobial phenotype |
| `VRE` / `vancomycin-resistant Enterococcus` | `ARO:3004329` | vancomycin-resistant Enterococcus |
| `MRSA` / `methicillin-resistant Staphylococcus aureus` | (look up in aro_index) | — |
| `ESBL-producing` | (look up in aro_index) | — |
| `CRE` | (look up in aro_index) | — |
| `CRKP` | (look up in aro_index) | — |

5. Apply common abbreviation expansions before lookup:

| Abbreviation | Expanded term for lookup |
|---|---|
| `ESBL` | extended-spectrum beta-lactamase |
| `CRE` | carbapenem-resistant Enterobacterales |
| `MRSA` | methicillin-resistant Staphylococcus aureus |
| `VRE` | vancomycin-resistant Enterococcus |
| `CRKP` | carbapenem-resistant Klebsiella pneumoniae |
| `MDR` | multidrug resistance antimicrobial phenotype |
| `PDR` | pan-drug resistance |

6. Attempt lookup against `aro_index` (exact → alias → substring).
7. Return the ARO ID in format `ARO:NNNNNNN`. If no confident match: return `null`.

---

## Matching Strategy

| Step | Type | Rule |
|------|------|------|
| 1 | Exact | Normalised phenotype name matches ARO preferred name (case-insensitive) |
| 2 | Abbreviation | Apply abbreviation expansion table above before matching |
| 3 | Alias | Normalised name matches any ARO synonym |
| 4 | Substring | ARO name contains the phenotype term |
| — | No match | Return `null`; do not fabricate IDs |

**Confidence threshold:** Only assign an ARO ID when confident the match describes the same resistance concept. A partial match to a tangentially related term is worse than `null`.

*What counts as tangentially related (return `null`):*
- Phenotype is `"fluoroquinolone resistance"` and the only ARO match is `"methicillin resistance"` — different drug class, different mechanism → `null`
- Phenotype is `"ESBL-producing"` and the only ARO substring match is `"ESBL inhibitor"` — the inhibitor entry describes a drug, not a resistance mechanism → `null`
- Phenotype is `"multidrug-resistant"` and matches a specific single-drug resistance term (e.g., `"vancomycin resistance"`) — too narrow for a broad phenotype → `null`; use the broad ARO class term instead if available

*What counts as an acceptable match (assign the ID):*
- Phenotype is `"ESBL-producing"` and ARO has `"extended-spectrum beta-lactamase"` as a preferred name or synonym → assign
- Phenotype is `"carbapenem-resistant"` and ARO has `"carbapenem resistance"` as a preferred name → assign
- Phenotype abbreviation expands (via abbreviation table) to a term that matches exactly → assign

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "amr_highlights": [
      {"value": "ESBL-producing", "aro_id": "ARO:3000026"},
      {"value": "multidrug-resistant (MDR)", "aro_id": "ARO:3000707"},
      {"value": "fluoroquinolone-resistant strains documented", "aro_id": "ARO:3000150"},
      {"value": "none documented", "aro_id": null}
    ]
  },
  "aro_notes": []
}
```

- Return the full `amr_highlights` list in original order, with `aro_id` populated where matched and `null` where not.
- Populate `aro_notes` when: no match found, abbreviation expansion used (note the expansion), web lookup used, CARD data source unavailable.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return ARO IDs confirmed from the ARO OBO ontology. Never guess or invent IDs. |
| Null on miss | If no confident match is found, return `null` — not the nearest approximate. |
| `none documented` | Always returns `aro_id: null` — sentinel value, not a phenotype. |
| `unknown` | Always returns `aro_id: null`. |
| Intrinsic structural resistance | Intrinsic glycopeptide/vancomycin insensitivity in commensals (Akkermansia, Bifidobacterium, Lactobacillales) has no ARO term. Always `null`. |
| OBO not `card.json` | Use `aro.obo` from OBO Foundry — `card.json` contains gene models only, not phenotype terms. |
| CARD website | CARD website (`card.mcmaster.ca`) is JavaScript-rendered and cannot be scraped. Do not attempt. |
| Non-blocking | Failure to fetch OBO does not halt the skill. Use confirmed mapping table, log failures in `aro_notes`. |
| Data currency | ARO OBO is actively maintained. If cached OBO is older than 6 months, note in `aro_notes` that a refresh is warranted. |
