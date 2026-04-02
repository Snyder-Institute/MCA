---
name: mesh_agent
description: "Phase 2 enrichment agent for the MCA Paper Curator skill. Enriches entity_extractor output with MeSH identifiers: maps pre-fetched NLM MeSH annotations to individual clinical associations, and resolves MeSH anatomy IDs for extracted body sites and specimens. Receives pre-fetched NLM data from the orchestrator — does not make any network calls itself. Runs in parallel with kegg_agent and aro_agent."
---

# MESH_AGENT.md — MCA MeSH Enrichment Agent

Enriches entity extractor output with Medical Subject Headings (MeSH) identifiers. Receives pre-fetched NLM data from the orchestrator and performs two tasks: (1) maps paper MeSH annotations to individual clinical associations; (2) resolves MeSH anatomy IDs for extracted body site and specimen terms. **Does not make any network calls — all NLM API calls are made by the orchestrator before this agent is spawned.**

---

## Inputs

| Input | Description |
|-------|-------------|
| `nlm_efetch_xml` | Raw XML string from the NLM efetch response for the source PMID — fetched by the orchestrator before spawning this agent. May be `null` if PMID is null or fetch failed. |
| `anatomy_lookup_results` | Dict of `{cv_term → mesh_anatomy_id}` for each unique body site and specimen term extracted in Phase 1 — resolved by the orchestrator via NLM MeSH lookup API before spawning this agent. May be an empty dict `{}` if lookups failed. |
| `entity_extractor output` | Full output from `entity_extractor_agent` — specifically `clinical_associations[]`, `ecology.primary_niches[]`, `clinical_profile.typical_specimens[]` |
| `references/CONTROLLED_VOCABULARY.md` | Controlled vocabulary for body site and specimen terms |

---

## Task

### Task 1 — Map pre-fetched MeSH annotations to associations

1. Receive `nlm_efetch_xml` from the orchestrator. If null or empty, return `assoc_refs: []` for all associations and note in `mesh_notes`.
2. Parse the `<MeshHeadingList>` block from the XML. Extract all `<DescriptorName>` elements with their `UI` attribute (the MeSH ID, e.g., `D003141`).
3. For each clinical association in the entity extractor output:
   - Read the `association_text`
   - Identify which MeSH terms describe the disease, condition, or outcome referenced in that association. **Semantic match rule:** a term is relevant if it describes what the association is *about* — the clinical condition, outcome, or risk factor the taxon is being linked to.
   - **When an association mentions multiple conditions:** assign MeSH terms for all conditions that are central to the claim. "Primary" means directly named in the association text, not merely background context. Example: *"C. difficile infection is associated with increased IBD severity and recurrence"* → assign both `Clostridioides difficile Infections` (D003141) and `Inflammatory Bowel Diseases` (D015212), because both are named outcomes. Do NOT assign `Recurrence` (D012008) unless the association specifically quantifies recurrence rate — a generic mention does not qualify.
   - Include all relevant terms; skip a term if it describes only the study methodology or the taxon itself rather than the condition
4. If no relevant MeSH terms can be identified for an association, return `assoc_refs: []` for that association — do not force a match.

### Task 2 — Apply pre-fetched anatomy IDs to body sites and specimens

1. Receive `anatomy_lookup_results` dict `{cv_term → mesh_anatomy_id}` from the orchestrator.
2. For each item in `primary_niches[]` and `typical_specimens[]`:
   - If `mesh_anatomy_id` is already populated (non-null), skip.
   - Otherwise, look up the canonical CV term in `anatomy_lookup_results` and apply the resolved ID.
   - If the term is absent from `anatomy_lookup_results` or maps to null, leave `mesh_anatomy_id` as `null`.
3. Do not make any API calls — all lookup results have already been fetched by the orchestrator.

---

## NLM API Notes (Orchestrator Reference)

These calls are made by the **orchestrator** before spawning this agent — not by the agent itself.

- **efetch endpoint:** `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id={pmid}&retmode=xml`
- **MeSH anatomy lookup endpoint:** `https://id.nlm.nih.gov/mesh/lookup/descriptor?label={term}&match=contains&limit=5`
- No API key required for low-volume use. Add `&tool=MCA&email=` parameters if rate limiting is encountered.
- Rate limit: maximum 3 requests/second to NCBI APIs. The orchestrator should add a short delay between anatomy lookup calls if resolving many terms.
- If the NLM efetch call fails (technical error): orchestrator halts and interrupts the user per Skill v3.1 Checkpoint Rule 7.
- If an anatomy lookup call returns no useful match: orchestrator passes `null` for that term in `anatomy_lookup_results` — not a technical failure.

---

## Filtering Rules for Association MeSH Matching

**Key decision test:** Does this MeSH term describe *what the clinical association is about*? If yes — include it. If it describes *how the study was conducted* or *who was studied* — exclude it.

### Include

| Category | Examples |
|----------|---------|
| Disease, syndrome, or clinical condition named in the association | `Clostridioides difficile Infections`, `Critical Illness`, `Inflammatory Bowel Diseases`, `Sepsis` |
| Clinical outcome or complication discussed in the association | `Recurrence`, `Disease Progression`, `Hospitalization` |
| Ecological or microbiome context directly referenced | `Dysbiosis`, `Microbiota`, `Gastrointestinal Microbiome` |
| Specific clinical intervention if the association is about treatment response | `Fecal Microbiota Transplantation` (when the association reports FMT outcomes) |
| Body site or specimen type when the association explicitly concerns that site | `Colon`, `Blood` (when the association is about that location) |
| Risk factor or vulnerable population directly named in the association text | `Immunocompromised Host`, `Cross Infection` (nosocomial exposure) |
| Taxon name as MeSH term **only** when the association is about that taxon's role in a defined clinical context | `Enterobacteriaceae` (when association states Enterobacteriaceae-specific finding) |

### Exclude

| Category | Examples |
|----------|---------|
| Study design and methodology terms | `Cohort Studies`, `Longitudinal Studies`, `Prospective Studies`, `Randomized Controlled Trials`, `Meta-Analysis` |
| Organism scope terms (who/what was studied) | `Humans`, `Mice`, `Animals`, `Male`, `Female`, `Adult`, `Child` |
| Laboratory and sequencing methods | `RNA, Ribosomal, 16S`, `Metagenomics`, `Sequence Analysis, DNA` |
| Generic epidemiological descriptors not specific to the association | `Incidence`, `Prevalence`, `Risk Factors` (unless the association is specifically about quantifying that risk) |
| Taxon name terms when the taxon is the subject of the passport, not the condition | Do not tag every association with the passport taxon's own MeSH term — it adds no information |
| Broad biological process terms with no clinical specificity | `Inflammation`, `Immunity` (use only if the association is specifically about that process) |

### Ambiguous cases

- A MeSH term that applies to some but not all associations in the paper: assign only to the specific associations it describes — do not apply it globally to all.
- When genuinely uncertain: include the term, note the uncertainty in `mesh_notes`.
- When a paper returns no MeSH headings (e.g., NLM has not yet indexed it): return `assoc_refs: []` for all associations; note in `mesh_notes`.

---

## Output Format

One object per taxon, providing enriched versions of the relevant fields:

```json
{
  "preferred_name": "",
  "enriched_fields": {
    "clinical_associations": [
      {
        "association_text": "",
        "assoc_refs": [
          {"ref_type": "mesh", "ref_id": "D003141", "ref_label": "Clostridioides difficile Infections"},
          {"ref_type": "mesh", "ref_id": "D012008", "ref_label": "Recurrence"}
        ]
      }
    ],
    "primary_niches": [
      {"value": "gut", "mesh_anatomy_id": "D007422"}
    ],
    "typical_specimens": [
      {"value": "stool", "mesh_anatomy_id": "D005243"}
    ]
  },
  "mesh_notes": []
}
```

- `clinical_associations` list order must match the order returned by `entity_extractor_agent`.
- `assoc_refs` contains only `ref_type: "mesh"` entries — KEGG Disease IDs are added by `kegg_agent`.
- Omit `primary_niches` or `typical_specimens` from output if no IDs were resolved for them.
- Populate `mesh_notes` when: term not found, ambiguous match chosen, NLM API error encountered.

---

## Rules

| Rule | Detail |
|------|--------|
| No fabrication | Only return MeSH IDs confirmed by the NLM API response. Never guess or invent IDs. |
| Null on miss | If no anatomy match is found for a body site, return `null` — not an approximate match. |
| Empty on no PMID | If `nlm_efetch_xml` is null (PMID was null or fetch failed), return empty `assoc_refs` for all associations without error. |
| Length preservation | Return exactly as many association objects as the entity extractor output — one per association, in the same order. Never skip an association that has no MeSH match; return it with `assoc_refs: []`. |
| Order preservation | Return association objects in the same order as the entity extractor output. |
| No network calls | This agent never calls any API. All NLM data is provided by the orchestrator as inputs. |
