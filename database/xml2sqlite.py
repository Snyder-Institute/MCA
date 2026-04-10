#!/usr/bin/env python3
"""
xml_to_sqlite.py — Download latest MCA XML from GitHub Releases and convert to SQLite.

Usage:
    python3 scripts/xml_to_sqlite.py

Output:
    scripts/MCA.sqlite   (drop this file into your Xcode project)

Options:
    --xml <path>    Use a local XML file instead of downloading from GitHub
    --out <path>    Output path (default: scripts/MCA.sqlite)

Notes:
    - Associations with evidence_grade UNCERTAIN are skipped (matches xml2sql.py behavior).
    - Surrogate integer PKs are assigned sequentially starting from 1.
"""

import sys
import os
import sqlite3
import urllib.request
import urllib.error
import json
import tempfile
import argparse
import xml.etree.ElementTree as ET
from datetime import date

GITHUB_API = "https://api.github.com/repos/Snyder-Institute/MCA/releases/latest"
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.join(SCRIPT_DIR, "MCA.sqlite")


# ── XML helpers ─────────────────────────────────────────────────────────────

def get_text(el, tag, default=None):
    child = el.find(tag)
    if child is None or not child.text:
        return default
    return child.text.strip()


TAG_SPECS = [
    ('Synonyms/synonym',                                   'synonym',            None),
    ('Biology/KeyTraits/key_trait',                        'key_trait',          None),
    ('Ecology/PrimaryNiches/primary_niche',                'primary_niche',      'mesh_anatomy_id'),
    ('Ecology/Reservoirs/reservoir',                       'reservoir',          None),
    ('Ecology/TransmissionRoutes/transmission_route',      'transmission_route', None),
    ('ClinicalProfile/ClinicalRoles/clinical_role',        'role',               None),
    ('ClinicalProfile/TypicalSpecimens/typical_specimen',  'typical_specimen',   'mesh_anatomy_id'),
    ('ClinicalProfile/RiskContexts/risk_context',          'risk_context',       None),
    ('ClinicalProfile/BloomTriggers/bloom_trigger',        'bloom_trigger',      'kegg_drug_id'),
    ('ClinicalProfile/AmrHighlights/amr_highlight',        'amr_highlight',      'aro_id'),
    ('ClinicalProfile/VirulenceFactors/virulence_factor',  'virulence_factor',   'vfdb_id'),
]


# ── Schema ───────────────────────────────────────────────────────────────────

SCHEMA = """
CREATE TABLE IF NOT EXISTS meta (
    key_name  TEXT PRIMARY KEY,
    key_value TEXT
);

CREATE TABLE IF NOT EXISTS paper (
    pmid         INTEGER PRIMARY KEY,
    title        TEXT,
    authors      TEXT,
    journal      TEXT,
    year         INTEGER,
    study_design TEXT,
    population   TEXT,
    sample_size  INTEGER
);

CREATE TABLE IF NOT EXISTS passport (
    id             INTEGER PRIMARY KEY,
    passport_id    TEXT UNIQUE NOT NULL,
    preferred_name TEXT,
    taxon_rank     TEXT,
    domain         TEXT,
    lineage        TEXT,
    ncbi_taxid     INTEGER,
    is_pathobiont  TEXT DEFAULT 'unknown',
    last_reviewed  TEXT,
    created_at     TEXT,
    updated_at     TEXT
);

CREATE TABLE IF NOT EXISTS biology (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    passport_id      INTEGER NOT NULL REFERENCES passport(id),
    gram_status      TEXT DEFAULT 'unknown',
    oxygen_tolerance TEXT DEFAULT 'unknown',
    morphology       TEXT,
    bacdive_url      TEXT,
    created_at       TEXT,
    updated_at       TEXT
);

CREATE TABLE IF NOT EXISTS taxon_tag (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    passport_id INTEGER NOT NULL REFERENCES passport(id),
    category    TEXT NOT NULL,
    value       TEXT NOT NULL,
    ext_id      TEXT,
    created_at  TEXT,
    updated_at  TEXT
);

CREATE TABLE IF NOT EXISTS metabolite (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    passport_id       INTEGER NOT NULL REFERENCES passport(id),
    metabolite_name   TEXT,
    relationship      TEXT DEFAULT 'produces',
    kegg_compound_id  TEXT,
    chebi_id          TEXT,
    created_at        TEXT,
    updated_at        TEXT
);

CREATE TABLE IF NOT EXISTS passport_pmid (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    passport_id INTEGER NOT NULL REFERENCES passport(id),
    pmid        INTEGER,
    created_at  TEXT
);

CREATE TABLE IF NOT EXISTS association (
    id               INTEGER PRIMARY KEY,
    passport_id      INTEGER NOT NULL REFERENCES passport(id),
    association_text TEXT,
    content_hash     TEXT,
    evidence_level   TEXT,
    evidence_type    TEXT,
    created_at       TEXT,
    updated_at       TEXT
);

CREATE TABLE IF NOT EXISTS assoc_ref (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    association_id INTEGER NOT NULL REFERENCES association(id),
    ref_type       TEXT,
    ref_id         TEXT,
    ref_label      TEXT,
    created_at     TEXT
);

CREATE TABLE IF NOT EXISTS assoc_pmid (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    association_id INTEGER NOT NULL REFERENCES association(id),
    pmid           INTEGER,
    created_at     TEXT
);

-- Full-text search index for passport search
CREATE VIRTUAL TABLE IF NOT EXISTS passport_fts USING fts5(
    passport_id UNINDEXED,
    preferred_name,
    lineage,
    content='passport',
    content_rowid='id'
);
"""

FTS_POPULATE = """
INSERT INTO passport_fts (rowid, passport_id, preferred_name, lineage)
    SELECT id, passport_id, preferred_name, lineage FROM passport;
"""


# ── GitHub download ──────────────────────────────────────────────────────────

def fetch_latest_xml(tmp_dir):
    print(f"Fetching latest release info from {GITHUB_API} ...")
    req = urllib.request.Request(GITHUB_API, headers={"Accept": "application/vnd.github+json",
                                                       "User-Agent": "MCA-iOS-build"})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            release = json.loads(resp.read())
    except urllib.error.HTTPError as e:
        sys.exit(f"GitHub API error: {e.code} {e.reason}")

    tag = release.get("tag_name", "unknown")
    assets = release.get("assets", [])

    xml_assets = [a for a in assets if a["name"].endswith(".xml")]
    if not xml_assets:
        sys.exit("No .xml asset found in the latest release.")

    asset = xml_assets[0]
    url = asset["browser_download_url"]
    name = asset["name"]
    print(f"  Release : {tag}")
    print(f"  Asset   : {name}")
    print(f"  URL     : {url}")

    xml_path = os.path.join(tmp_dir, name)
    print(f"Downloading ...")
    urllib.request.urlretrieve(url, xml_path)
    print(f"  Saved to: {xml_path}")
    return xml_path, tag


# ── XML → SQLite ─────────────────────────────────────────────────────────────

def convert(xml_path, out_path):
    today = date.today().isoformat()

    print(f"\nParsing XML: {xml_path}")
    tree = ET.parse(xml_path)
    root = tree.getroot()

    if os.path.exists(out_path):
        os.remove(out_path)

    conn = sqlite3.connect(out_path)
    conn.execute("PRAGMA journal_mode=DELETE")
    conn.execute("PRAGMA foreign_keys=ON")
    conn.executescript(SCHEMA)

    passport_pk = {}
    passport_counter = 1
    assoc_counter = 1
    skipped_assocs = 0

    # ── meta ──
    meta_el = root.find('Meta')
    if meta_el is not None:
        db_version = get_text(meta_el, 'version', 'unknown')
        conn.execute("INSERT OR REPLACE INTO meta (key_name, key_value) VALUES ('db_version', ?)",
                     (db_version,))
        print(f"  DB version: {db_version}")

    # ── papers ──
    papers_el = root.find('Papers')
    if papers_el is not None:
        for paper_el in papers_el.findall('Paper'):
            pmid = paper_el.findtext('pmid')
            if not pmid:
                continue
            conn.execute(
                "INSERT OR REPLACE INTO paper "
                "(pmid, title, authors, journal, year, study_design, population, sample_size) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                (
                    int(pmid),
                    get_text(paper_el, 'title'),
                    get_text(paper_el, 'authors'),
                    get_text(paper_el, 'journal'),
                    _int(get_text(paper_el, 'year')),
                    get_text(paper_el, 'study_design'),
                    get_text(paper_el, 'population'),
                    _int(get_text(paper_el, 'sample_size')),
                )
            )

    # ── passports ──
    passports = root.findall('TaxonPassport')
    print(f"  Passports found: {len(passports)}")

    for tp in passports:
        pid_str = get_text(tp, 'passport_id')
        p_pk = passport_counter
        passport_pk[pid_str] = p_pk
        passport_counter += 1

        preferred_name = get_text(tp, 'preferred_name')
        created_at     = get_text(tp, 'created_at', today)
        updated_at     = get_text(tp, 'updated_at', today)

        conn.execute(
            "INSERT INTO passport "
            "(id, passport_id, preferred_name, taxon_rank, domain, lineage, "
            "ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                p_pk,
                pid_str,
                preferred_name,
                get_text(tp, 'taxon_rank'),
                get_text(tp, 'domain'),
                get_text(tp, 'lineage'),
                _int(get_text(tp, 'ncbi_taxid')),
                get_text(tp, 'is_pathobiont', 'unknown'),
                get_text(tp, 'last_reviewed', today),
                created_at,
                updated_at,
            )
        )

        # ── biology ──
        bio = tp.find('Biology')
        if bio is not None:
            conn.execute(
                "INSERT INTO biology "
                "(passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) "
                "VALUES (?, ?, ?, ?, ?, ?, ?)",
                (
                    p_pk,
                    get_text(bio, 'gram_status', 'unknown'),
                    get_text(bio, 'oxygen_tolerance', 'unknown'),
                    get_text(bio, 'morphology'),
                    get_text(bio, 'bacdive_url'),
                    created_at,
                    updated_at,
                )
            )

        # ── taxon_tag ──
        for (xpath, category, attr) in TAG_SPECS:
            for el in tp.findall(xpath):
                val = el.text.strip() if el.text else None
                if not val:
                    continue
                ext = el.get(attr) if attr else None
                conn.execute(
                    "INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) "
                    "VALUES (?, ?, ?, ?, ?, ?)",
                    (p_pk, category, val, ext, created_at, updated_at)
                )

        # ── metabolites ──
        for met in tp.findall('Metabolites/Metabolite'):
            mname = get_text(met, 'metabolite_name')
            if mname:
                conn.execute(
                    "INSERT INTO metabolite "
                    "(passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?)",
                    (
                        p_pk,
                        mname,
                        get_text(met, 'relationship', 'produces'),
                        get_text(met, 'kegg_compound_id'),
                        get_text(met, 'chebi_id'),
                        created_at,
                        updated_at,
                    )
                )

        # ── passport_pmid ──
        for pmid_el in tp.findall('TaxonEvidencePmids/pmid'):
            if pmid_el.text:
                conn.execute(
                    "INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (?, ?, ?)",
                    (p_pk, _int(pmid_el.text.strip()), created_at)
                )

        # ── associations ──
        for ca in tp.findall('ClinicalAssociations/ClinicalAssociation'):
            assoc_text   = get_text(ca, 'association_text')
            content_hash = get_text(ca, 'content_hash')
            ev_grade     = get_text(ca, 'evidence_level')
            ev_type      = get_text(ca, 'evidence_type')

            if not content_hash:
                print(f"  WARNING: skipped association on {pid_str} — missing content_hash",
                      file=sys.stderr)
                skipped_assocs += 1
                continue

            if not ev_grade:
                print(f"  WARNING: missing evidence_level on {pid_str} — skipping",
                      file=sys.stderr)
                skipped_assocs += 1
                continue

            if ev_grade == 'UNCERTAIN':
                skipped_assocs += 1
                continue

            a_pk = assoc_counter
            assoc_counter += 1

            conn.execute(
                "INSERT INTO association "
                "(id, passport_id, association_text, content_hash, evidence_level, evidence_type, "
                "created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                (a_pk, p_pk, assoc_text, content_hash, ev_grade, ev_type, created_at, updated_at)
            )

            # assoc_refs
            for ref in ca.findall('AssocRefs/ref') + ca.findall('AssocRefs/assoc_ref'):
                ref_type  = ref.get('type')  or get_text(ref, 'ref_type')
                ref_id    = ref.get('id')    or get_text(ref, 'ref_id')
                ref_label = ref.get('label') or get_text(ref, 'ref_label')
                if ref_type and ref_id:
                    conn.execute(
                        "INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) "
                        "VALUES (?, ?, ?, ?, ?)",
                        (a_pk, ref_type, ref_id, ref_label, created_at)
                    )

            # assoc_pmids
            for pmid_el in ca.findall('Pmids/pmid'):
                if pmid_el.text:
                    conn.execute(
                        "INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (?, ?, ?)",
                        (a_pk, _int(pmid_el.text.strip()), created_at)
                    )

    # ── FTS index ──
    conn.executescript(FTS_POPULATE)

    conn.commit()
    conn.close()

    n_passports = passport_counter - 1
    n_assocs    = assoc_counter - 1
    print(f"\nWritten : {out_path}")
    print(f"  Passports    : {n_passports}")
    print(f"  Associations : {n_assocs}")
    if skipped_assocs:
        print(f"  Skipped      : {skipped_assocs} (UNCERTAIN or invalid)")


def _int(v):
    if v is None:
        return None
    try:
        return int(v)
    except (ValueError, TypeError):
        return None


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Download MCA XML release and convert to SQLite.")
    parser.add_argument("--xml", help="Use a local XML file instead of downloading from GitHub")
    parser.add_argument("--out", default=DEFAULT_OUT, help=f"Output .sqlite path (default: {DEFAULT_OUT})")
    args = parser.parse_args()

    if args.xml:
        xml_path = args.xml
        convert(xml_path, args.out)
    else:
        with tempfile.TemporaryDirectory() as tmp_dir:
            xml_path, _ = fetch_latest_xml(tmp_dir)
            convert(xml_path, args.out)


if __name__ == '__main__':
    main()
