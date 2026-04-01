# GRADING_CRITERIA.md — Evidence Grading Criteria for MCA Clinical Associations

Used by `agents/GRADING_AGENT.md` to assign a single evidence grade to a paper and write a rationale. One grade is assigned per paper and applies to all clinical associations extracted from it.

---

## Evidence Grade Definitions

| Grade | Label | Definition |
|-------|-------|------------|
| **E3** | Strong human clinical evidence | Broadly accepted in clinical practice. Supported by official clinical guidelines, systematic reviews, or meta-analyses of human studies. |
| **E2** | Moderate human evidence | Direct evidence in humans exists but may be context-dependent or limited in scope. Supported by well-designed observational studies (cohort, case-control). |
| **E1** | Limited / preliminary | Suggestive but not yet established in humans. Supported by animal models, in vitro studies, isolated case reports, or mechanistic/exploratory work. |

---

## Study Design Classification

Use the study design identified in Phase 0 (paper analysis) to assign the grade. Match to the highest applicable tier.

### E3 — Strong human clinical evidence
Assign E3 if the paper is one of the following:
- Systematic review or meta-analysis of human clinical studies
- Clinical practice guideline citing microbiome evidence
- Multiple independent human cohorts (or trials) confirming the same finding within a single paper (e.g., discovery cohort + replication cohort, or pooled multi-centre analysis)

**Key signal phrases in paper:** "systematic review", "meta-analysis", "clinical guideline", "PRISMA", "GRADE", "replication cohort", "multi-centre", "pooled analysis"

### E2 — Moderate human evidence
Assign E2 if the paper is one of the following:
- Single prospective or retrospective cohort study in humans
- Single randomized controlled trial (RCT) with microbiome outcome data
- Case-control study in humans
- Cross-sectional study with a well-defined clinical outcome
- Secondary analysis of a clinical trial with microbiome data

**Key signal phrases in paper:** "cohort", "case-control", "cross-sectional", "randomized", "odds ratio", "hazard ratio", "human subjects", "patients enrolled"

### E1 — Limited / preliminary
Assign E1 if the paper is one of the following:
- Animal model study (mouse, rat, gnotobiotic, etc.)
- In vitro or ex vivo study
- Case report or case series (< 5 subjects)
- Mechanistic study (e.g., metabolomics, genomics without clinical outcome)
- Pilot or exploratory study with no clinical comparator
- Conference abstract or preprint (flag explicitly)

**Key signal phrases in paper:** "murine model", "mouse model", "in vitro", "cell line", "case report", "pilot", "exploratory", "mechanistic", "preprint"

---

## Grading Decision Logic

```
1. Identify study design from paper metadata (Phase 0 output)
2. Match study design to tier above (E3 → E2 → E1)
3. If paper contains mixed designs (e.g., human cohort + mouse validation):
   → Assign grade based on the PRIMARY human data component
   → Note the mixed design in the rationale
4. If study design is ambiguous or not reported:
   → Flag as UNCERTAIN (see below)
```

---

## Uncertainty Flag

Flag the paper as `UNCERTAIN` when:
- Study design is not clearly stated or cannot be determined from the PDF
- The paper describes a novel methodology with no clear precedent in the tier list
- The paper is a review but does not meet systematic review standards (narrative review)
- The paper reports microbiome associations as secondary/exploratory endpoints only, with no primary clinical outcome

**When flagged:** Do not assign a grade. Write an `uncertain_reason` explaining what is unclear. The staging file is still written with `grade: UNCERTAIN` and the `uncertain_reason` populated — it is not held back. The user reviews and resolves the uncertainty when inspecting the staging file.

---

## Rationale Format

Write 2–3 sentences covering:
1. The study design type identified
2. Why it maps to the assigned grade
3. Any caveats (e.g., small sample size, single-centre, mixed design)

**Example (E2):**
> "This is a prospective cohort study enrolling 312 patients with IBD, with microbiome profiling at baseline and 12-month follow-up. Human observational evidence with a defined clinical outcome qualifies for E2. Caveats: single-centre, no randomisation, and microbiome associations are secondary endpoints."

**Example (E1):**
> "This is a gnotobiotic mouse study examining colonisation dynamics of *Clostridioides difficile* under antibiotic perturbation. Animal model evidence without a parallel human cohort qualifies for E1. Findings are mechanistic and should be interpreted as hypothesis-generating."

**Example (UNCERTAIN):**
> "The paper describes an exploratory analysis but does not specify a prospective or retrospective design, and the comparator group is unclear. Study design cannot be confidently mapped to a grading tier. User review required before grading."

---

## What Grade Does NOT Capture

- The quality of microbiome methodology (sequencing depth, 16S vs WGS, batch correction) — note in rationale if relevant but do not adjust grade for it
- Journal impact factor or prestige
- Whether the taxon is the primary focus or incidentally mentioned
- Replication status (a single high-quality RCT still qualifies as E3)
