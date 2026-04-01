# VERSIONING.md — MCA Database Version Convention

Defines the versioning scheme for `database/MCA_DB_*.xml` files and the `<version>` field inside each `<TaxonPassport>`.

---

## Format

```
vMAJOR_MINOR_YYYYMMDD
```

**Example:** `v0_1_20260331`

| Component | Description |
|-----------|-------------|
| `v` | Literal prefix, always present |
| `MAJOR` | Major release number |
| `MINOR` | Minor release number |
| `YYYYMMDD` | Date of the XML update (4-digit year, 2-digit month, 2-digit day) |

---

## Component Rules

### MAJOR
- Currently `0` — not yet publicly released.
- Increment to `1` on first public release, or on breaking changes to the database schema.
- Only bumped on explicit instruction from the maintainer.

### MINOR
- Currently `1` — proof of concept.
- Increment for significant but non-breaking changes: mass record additions, minor structural changes, or bug fixes.
- Only bumped on explicit instruction from the maintainer.

### YYYYMMDD
- Updated automatically by Skill 2 (mca-xml-update) every time a new XML file is written.
- Reflects the date the XML was last modified.
- Maximum one XML write per day — if multiple staging files are applied in the same session, they are batched into a single output file with the same date.

---

## File Naming

XML files in `database/` follow the same version string:

```
MCA_DB_vMAJOR_MINOR_YYYYMMDD.xml
```

**Example:** `database/MCA_DB_v0_1_20260331.xml`

---

## Snapshot Behaviour (Skill 2)

Skill 2 (mca-xml-update) **never overwrites** an existing XML file. Each run produces a new file with today's date in the filename. Previous versions are preserved in `database/` as immutable snapshots.

```
database/
├── MCA_DB_v0_1_20260303.xml   ← original, preserved
├── MCA_DB_v0_1_20260331.xml   ← produced by Skill 2 on 2026-03-31
└── MCA_DB_v0_1_20260401.xml   ← produced by Skill 2 on 2026-04-01
```

The most recent file (highest YYYYMMDD for the current MAJOR_MINOR) is the canonical version.

---

## `<version>` Field in TaxonPassport

Each `<TaxonPassport>` carries a `<version>` field that stores the full version string of the XML file at the time the passport was last written or updated.

```xml
<version>v0_1_20260331</version>
```

- **On CREATE:** set to the version string of the output XML file.
- **On UPDATE:** set to the version string of the output XML file.
- Passports not touched in a given Skill 2 run retain their previous `<version>` value.

This means `<version>` on a passport records which snapshot last modified it, not the current DB version — making each passport self-describing.

---

## Routing Agent Note

When Skill 1 (mca-paper-curator) searches for existing passports, it should always read the **most recent XML file** (highest YYYYMMDD for the current MAJOR_MINOR track) in `database/`.

If **no XML file exists** (fresh-start workflow), the routing agent routes all taxa as `CREATE` with `passport_id: null`. No XML is required for mca-paper-curator to complete — it only writes staging files. Skill 2 (mca-xml-update) will bootstrap the XML via `xsd_writer_agent` before applying the first staging file.
