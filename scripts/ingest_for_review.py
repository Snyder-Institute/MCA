#!/usr/bin/env python3
"""ingest_for_review.py — populate MCA_review.association_snapshot from staging JSONs.

For every staging JSON in review_data/staging/, the script:
  1. Reads source_paper.pmid (skips files where paper is not in MCA.paper).
  2. Walks proposed_changes.clinical_associations[] and emits one
     row per claim into MCA_review.association_snapshot, keyed by
     association_uid = "<file_stem>__<idx>".
  3. Stores the rest of proposed_changes (biology, ecology,
     clinical_profile, synonyms, taxon-level metadata) as a JSON blob
     in association_snapshot.context_json so review_paper.php can
     render the read-only context section without re-reading staging files.

When a staging file's PMID has multiple drafts (e.g. with and without
PMID suffix in filename), all rows are inserted — `association_uid`
disambiguates.

Run order: sync_review_data.py -> extract_abstracts.py -> this.

Usage (run from repo root):
    python3 scripts/ingest_for_review.py [--truncate]
"""

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _db  # noqa: E402

STAGING_DIR = Path(__file__).resolve().parent.parent / "review_data" / "staging"
KEGG_INDEX = Path(__file__).resolve().parent.parent / "web" / "data" / "kegg_brite_index.json"


def _load_kegg_names() -> dict[str, str]:
    """Build a flat KEGG-id -> name map from the brite index, if present."""
    if not KEGG_INDEX.exists():
        return {}
    idx = json.loads(KEGG_INDEX.read_text())
    names: dict[str, str] = {}
    for k in ("disease_names", "drug_names", "compound_names"):
        names.update(idx.get(k) or {})
    return names


def _fill_ref_labels(refs: list, kegg_names: dict[str, str]) -> list:
    """Resolve missing ref_label values for KEGG ids using the brite index."""
    if not refs:
        return refs
    out = []
    for r in refs:
        if not isinstance(r, dict):
            continue
        if not r.get("ref_label") and r.get("ref_id") and r.get("ref_type", "").startswith("kegg"):
            name = kegg_names.get(r["ref_id"])
            if name:
                r = dict(r)
                r["ref_label"] = name
        out.append(r)
    return out


def _resolve_passport_id(mca_cur, preferred_name: str) -> str | None:
    if not preferred_name:
        return None
    mca_cur.execute(
        "SELECT passport_id FROM passport WHERE preferred_name = %s LIMIT 1",
        (preferred_name,),
    )
    row = mca_cur.fetchone()
    return row["passport_id"] if row else None


def _supporting_pmids(assoc: dict) -> str:
    pmids = assoc.get("pmids") or []
    return ",".join(str(p) for p in pmids if p)


def _hydrate_from_mca(mca_conn, passport_id_str: str) -> dict:
    """Build a proposed_changes-shaped dict for an existing MCA passport.

    UPDATE-action staging files only carry the fields that are changing.
    To render full reviewer context (biology, ecology, clinical profile,
    metabolites) we pull the canonical passport data from MCA and use it
    wherever the staging file is silent.
    """
    if not passport_id_str:
        return {}
    with mca_conn.cursor() as c:
        c.execute("SELECT * FROM passport WHERE passport_id = %s", (passport_id_str,))
        passport = c.fetchone()
        if not passport:
            return {}
        pid_int = passport["id"]
        c.execute("SELECT * FROM biology WHERE passport_id = %s", (pid_int,))
        biology = c.fetchone()
        c.execute(
            "SELECT category, value, ext_id FROM taxon_tag "
            "WHERE passport_id = %s ORDER BY category, value",
            (pid_int,),
        )
        tags = c.fetchall()
        c.execute(
            "SELECT metabolite_name, relationship, kegg_compound_id, chebi_id "
            "FROM metabolite WHERE passport_id = %s ORDER BY metabolite_name",
            (pid_int,),
        )
        metabolites = c.fetchall()

    by_cat: dict[str, list] = {}
    for t in tags:
        by_cat.setdefault(t["category"], []).append(t)

    def _id_payload(t: dict, key: str) -> dict:
        return {"value": t["value"], key: t.get("ext_id")} if t.get("ext_id") else {"value": t["value"]}

    def _risk_payload(t: dict) -> dict:
        ext = t.get("ext_id")
        if not ext:
            return {"value": t["value"]}
        if ext.startswith("H"):
            return {"value": t["value"], "kegg_disease_id": ext}
        return {"value": t["value"], "mesh_disease_id": ext}

    identity = {
        "preferred_name": passport["preferred_name"],
        "taxon_rank":     passport["taxon_rank"],
        "domain":         passport["domain"],
        "lineage":        passport["lineage"],
        "ncbi_taxid":     passport["ncbi_taxid"],
        "synonyms":       [t["value"] for t in by_cat.get("synonym", [])],
    }
    bio = None
    if biology:
        bio = {
            "gram_status":      biology["gram_status"],
            "oxygen_tolerance": biology["oxygen_tolerance"],
            "morphology":       biology["morphology"],
            "bacdive_url":      biology.get("bacdive_url"),
            "key_traits":       [t["value"] for t in by_cat.get("key_trait", [])],
        }
    ecology = {
        "primary_niches":      [_id_payload(t, "mesh_anatomy_id") for t in by_cat.get("primary_niche", [])],
        "reservoirs":          [t["value"] for t in by_cat.get("reservoir", [])],
        "transmission_routes": [t["value"] for t in by_cat.get("transmission_route", [])],
    }
    cp = {
        "is_pathobiont":     passport.get("is_pathobiont"),
        "clinical_roles":    [t["value"] for t in by_cat.get("role", [])],
        "typical_specimens": [_id_payload(t, "mesh_anatomy_id") for t in by_cat.get("typical_specimen", [])],
        "bloom_triggers":    [_id_payload(t, "kegg_drug_id") for t in by_cat.get("bloom_trigger", [])],
        "risk_contexts":     [_risk_payload(t) for t in by_cat.get("risk_context", [])],
        "amr_highlights":    [_id_payload(t, "aro_id") for t in by_cat.get("amr_highlight", [])],
    }
    mets = [
        {
            "metabolite_name":  m["metabolite_name"],
            "relationship":     m["relationship"],
            "kegg_compound_id": m.get("kegg_compound_id"),
            "chebi_id":         m.get("chebi_id"),
        }
        for m in metabolites
    ]

    return {
        "identity":         identity,
        "biology":          bio,
        "ecology":          ecology,
        "clinical_profile": cp,
        "metabolites":      mets,
    }


def _context_json(staging: dict, mca_payload: dict) -> str:
    """Serialize the context payload for review_paper.php.

    Staging-file values take precedence; whatever is null in the staging
    file is back-filled from `mca_payload` (the canonical passport).
    """
    pc = staging.get("proposed_changes", {}) or {}
    payload = {
        "identity":         pc.get("identity")         or mca_payload.get("identity"),
        "biology":          pc.get("biology")          or mca_payload.get("biology"),
        "ecology":          pc.get("ecology")          or mca_payload.get("ecology"),
        "clinical_profile": pc.get("clinical_profile") or mca_payload.get("clinical_profile"),
        "metabolites":      pc.get("metabolites")      or mca_payload.get("metabolites"),
        "taxon_level_pmids": pc.get("taxon_level_pmids"),
        "evidence":          staging.get("evidence"),
        "extraction_notes":  staging.get("extraction_notes"),
        "source_paper":      staging.get("source_paper"),
    }
    return json.dumps(payload, ensure_ascii=False)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument(
        "--truncate", action="store_true",
        help="empty association_snapshot before re-ingest",
    )
    args = ap.parse_args()

    if not STAGING_DIR.is_dir():
        sys.exit(f"ERROR: staging dir missing: {STAGING_DIR}")

    files = sorted(STAGING_DIR.glob("*.json"))
    if not files:
        sys.exit(f"ERROR: no staging JSONs in {STAGING_DIR}")

    kegg_names = _load_kegg_names()
    if not kegg_names:
        print("  ! KEGG brite index missing — labels will not be back-filled.")

    with _db.mca() as mca_conn, _db.mca_review() as rev_conn:
        with mca_conn.cursor() as mc:
            mc.execute("SELECT pmid FROM paper")
            valid_pmids = {row["pmid"] for row in mc.fetchall()}

        with rev_conn.cursor() as rc:
            if args.truncate:
                rc.execute("DELETE FROM association_snapshot")

            n_files = n_skipped = n_assocs = 0
            for fpath in files:
                with fpath.open() as fh:
                    staging = json.load(fh)

                src = staging.get("source_paper") or {}
                pmid = src.get("pmid")
                if not pmid or int(pmid) not in valid_pmids:
                    n_skipped += 1
                    continue
                pmid = int(pmid)

                # Identity may be omitted on UPDATE-action staging files when
                # the existing passport's identity isn't being changed. In that
                # case, fall back to looking up the passport_id at the top of
                # the staging JSON and reading the canonical name from MCA.
                identity = (staging.get("proposed_changes") or {}).get("identity") or {}
                taxon_name = identity.get("preferred_name")
                taxon_rank = identity.get("taxon_rank")
                passport_id = staging.get("passport_id") or ""

                if passport_id and (not taxon_name or not taxon_rank):
                    with mca_conn.cursor() as mc:
                        mc.execute(
                            "SELECT preferred_name, taxon_rank FROM passport "
                            "WHERE passport_id = %s LIMIT 1",
                            (passport_id,),
                        )
                        row = mc.fetchone()
                        if row:
                            taxon_name = taxon_name or row["preferred_name"]
                            taxon_rank = taxon_rank or row["taxon_rank"]

                if not taxon_name:
                    taxon_name = "(unknown)"

                if not passport_id and taxon_name != "(unknown)":
                    with mca_conn.cursor() as mc:
                        passport_id = _resolve_passport_id(mc, taxon_name) or ""

                mca_payload = _hydrate_from_mca(mca_conn, passport_id) if passport_id else {}
                ctx_json = _context_json(staging, mca_payload)

                associations = (staging.get("proposed_changes") or {}).get(
                    "clinical_associations"
                ) or []
                stem = fpath.stem
                for idx, a in enumerate(associations):
                    uid = f"{stem}__{idx}"
                    rc.execute(
                        """
                        INSERT INTO association_snapshot
                            (association_uid, pmid, taxon_passport_id,
                             taxon_name, taxon_rank, association_text,
                             evidence_level, supporting_pmids, assoc_refs_json,
                             context_json)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON DUPLICATE KEY UPDATE
                            pmid=VALUES(pmid),
                            taxon_passport_id=VALUES(taxon_passport_id),
                            taxon_name=VALUES(taxon_name),
                            taxon_rank=VALUES(taxon_rank),
                            association_text=VALUES(association_text),
                            evidence_level=VALUES(evidence_level),
                            supporting_pmids=VALUES(supporting_pmids),
                            assoc_refs_json=VALUES(assoc_refs_json),
                            context_json=VALUES(context_json)
                        """,
                        (
                            uid, pmid, passport_id, taxon_name, taxon_rank,
                            a.get("association_text") or "",
                            a.get("evidence_level") or "E1",
                            _supporting_pmids(a),
                            json.dumps(_fill_ref_labels(a.get("assoc_refs") or [], kegg_names),
                                       ensure_ascii=False),
                            ctx_json,
                        ),
                    )
                    n_assocs += 1
                n_files += 1

        rev_conn.commit()

    print(f"Ingested staging files       : {n_files:3d}")
    print(f"Skipped (PMID not in MCA)    : {n_skipped:3d}")
    print(f"Associations written         : {n_assocs:3d}")


if __name__ == "__main__":
    main()
