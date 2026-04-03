---
name: vfdb_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Maps extracted virulence factor names to VFDB identifiers (VFIDs) using a local JSON mirror of the Virulence Factor Database. Runs in parallel with mesh_agent, kegg_agent, and aro_agent."
---

# VFDB_AGENT.md — MCA Virulence Factor Database Enrichment Agent

Maps virulence factor names extracted by `entity_extractor_agent` to stable VFDB identifiers (VFIDs) using a local JSON mirror of the [Virulence Factor Database (VFDB)](https://www.mgc.ac.cn/VFs/).

**VFDB:** mgc.ac.cn/VFs — maintained by the Institute of Microbiology, Chinese Academy of Sciences.  
**VFID format:** `VF` + 4-digit number, e.g. `VF0592`

---

## Background

VFDB curates experimentally verified virulence factors from medically significant bacterial pathogens. Each VF entry has:
- A stable identifier: `VFxxxx` (e.g., `VF0592`)
- A short name (e.g., `TcdA`, `Alpha-hemolysin`, `CagA`)
- A full name (e.g., `Toxin A`, `Alpha-hemolysin`)
- A functional category (e.g., `Exotoxin`, `Adherence`, `Effector delivery system`)
- A bacterial host (genus/species, e.g., `Clostridium difficile`)

MCA stores VFDB IDs on `virulence_factor` taxon tags to make virulence factor annotations machine-readable and cross-database queryable.

**Important alias:** VFDB uses the old name `Clostridium difficile`. In the local JSON file this is aliased to `clostridioides difficile` — the lookup will find entries correctly under either name.

---

## Inputs

| Input | Description |
|-------|-------------|
| `entity_extractor output` | `clinical_profile.virulence_factors[]` — list of `{value, vfdb_id: null}` objects |
| `taxon preferred_name` | Used to look up the organism in the local VFDB JSON |
| `vfdb_path` | Absolute path to the local VFDB JSON mirror — resolved by the orchestrator from project memory (`reference_vfdb_path.md`) before this agent is called. The orchestrator must pass this path explicitly; the agent does not access memory directly. |

---

## Data Source

**Local VFDB JSON mirror (required):**

Path is passed by the orchestrator as `vfdb_path` (resolved from project memory `reference_vfdb_path.md`).

This file was generated from `VFs.xls` (VFDB Set A — 711 curated prototype VFs, downloaded 2026-03-27). It is a JSON object keyed by **lowercase organism name**, where each value is an array of VF entries:

```json
{
  "staphylococcus aureus": [
    {
      "vfid": "VF0001",
      "vf_name": "Alpha-hemolysin",
      "vf_fullname": "Alpha-hemolysin",
      "vfcid": "VFC0010",
      "vf_category": "Exotoxin",
      "function": "...",
      "mechanism": "..."
    }
  ]
}
```

**There is no web API fallback.** VFDB's website is unstable — do not make network calls to `mgc.ac.cn`. If the local file is inaccessible, log in `vfdb_notes` and return all `vfdb_id: null`.

---

## Task

### Task 1 — Load local VFDB index

1. Read the file at `vfdb_path` (passed by orchestrator) using the Read tool.
2. Parse the JSON and build a lookup keyed by lowercase organism name.
3. Find the entry for the taxon being processed:
   - Normalise the taxon's `preferred_name` to lowercase (e.g., `"Staphylococcus aureus"` → `"staphylococcus aureus"`)
   - Look up that key in the JSON
   - If not found: also try genus-only match (first word of preferred_name)
   - If still not found: log in `vfdb_notes` ("Taxon not covered by VFDB") and return all `vfdb_id: null`
4. Store the list of VF entries for this taxon as `taxon_vf_list`.

### Task 2 — Map virulence factor names to VFIDs

For each item in `virulence_factors[]`:
1. Take the `value` field (e.g., `"TcdA"`, `"alpha toxin"`, `"toxin A"`)
2. Normalise: lowercase, strip qualifiers (`-producing`, `type`, etc.)
3. Attempt match against `taxon_vf_list` in this order:

| Step | Match type | Rule |
|------|-----------|------|
| 1 | Exact `vf_name` | Lowercase `value` == lowercase `vf_name` |
| 2 | Exact `vf_fullname` | Lowercase `value` == lowercase `vf_fullname` |
| 3 | Substring `vf_name` | `vf_name` contains the normalised value (or vice versa) |
| 4 | Substring `vf_fullname` | `vf_fullname` contains the normalised value (or vice versa) |
| — | No match | Return `null`; do not fabricate IDs |

4. Return the matched `vfid` (e.g., `"VF0592"`). If no confident match: return `null`.

### Task 3 — Handle organism name aliases

| Paper name | JSON key to try |
|-----------|----------------|
| *Clostridioides difficile* | `clostridioides difficile` (alias key present in JSON — no extra mapping needed) |
| *Escherichia coli* (any pathotype) | `escherichia coli (upec)`, `escherichia coli (ehec)`, etc. — try all `escherichia coli*` keys; return best match per VF name |
| *Salmonella enterica* | Try `salmonella enterica (serovar typhimurium)` and `salmonella enterica (serovar typhi)` — union the VF lists |

---

## Output Format

One object per taxon:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "virulence_factors": [
      {"value": "TcdA", "vfdb_id": "VF0592"},
      {"value": "TcdB", "vfdb_id": "VF0593"},
      {"value": "binary toxin CDT", "vfdb_id": null}
    ]
  },
  "vfdb_notes": []
}
```

- Return the full `virulence_factors` list in original order, with `vfdb_id` populated where matched and `null` where not.
- Populate `vfdb_notes` when: taxon not covered by VFDB, no match found for a specific VF name, alias mapping used, local file inaccessible.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return VFIDs confirmed in the local JSON. Never guess or invent IDs. |
| Null on miss | If no confident match is found, return `null` — not the nearest approximate. |
| No network calls | Do not contact mgc.ac.cn or any web URL. Local file only. |
| Non-blocking | Failure to read the local file does not halt the skill. Log in `vfdb_notes` and return all `vfdb_id: null`. |
| Organism scope | Only match VFs from the organism's own entry in the JSON — do not cross-contaminate with VFs from other organisms. |
| `none documented` | Always returns `vfdb_id: null` — it is a sentinel value, not a VF name. |
| Data currency | The local JSON reflects VFDB Set A as of 2026-03-27. Note in `vfdb_notes` if a VF name appears plausible but is absent from the file (suggests the entry may be in Set B or post-2026 additions). |
