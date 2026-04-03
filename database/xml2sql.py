#!/usr/bin/env python3
"""
xml2sql.py — Convert an MCA XML database snapshot to MySQL INSERT statements.

Usage:
    python3 xml2sql.py database/MCA_DB_v1_0_20260401.xml

Output:
    database/MCA_DB_v1_0_20260401.sql  (same directory, same stem, .sql extension)

Import into MySQL:
    mysql MCA < database/MCA_DB_v1_0_20260401.sql

Notes:
    - Associations with evidence_grade UNCERTAIN are skipped (not in the SQL ENUM)
      and a warning is printed to stderr.
    - Surrogate integer PKs are assigned sequentially starting from 1.
      They are stable within a single run but will differ across runs if the
      XML changes — the canonical stable identifier is passport_id (e.g. MCA-BAC-000001).
"""

import sys
import os
import xml.etree.ElementTree as ET
from datetime import date


def esc(s):
    """Escape a value as a MySQL single-quoted string, or return bare NULL."""
    if s is None:
        return 'NULL'
    return "'" + str(s).replace('\\', '\\\\').replace("'", "\\'") + "'"


def esc_int(v):
    """Return a bare integer literal, or NULL."""
    if v is None:
        return 'NULL'
    try:
        return str(int(v))
    except (ValueError, TypeError):
        return 'NULL'


def get_text(el, tag, default=None):
    """Return stripped text of a direct child element, or default."""
    child = el.find(tag)
    if child is None or not child.text:
        return default
    return child.text.strip()


# Tag list specs: (XPath relative to TaxonPassport, SQL category value, ext_id attribute name or None)
TAG_SPECS = [
    ('Synonyms/synonym',                                  'synonym',            None),
    ('Biology/KeyTraits/key_trait',                       'key_trait',          None),
    ('Ecology/PrimaryNiches/primary_niche',               'primary_niche',      'mesh_anatomy_id'),
    ('Ecology/Reservoirs/reservoir',                      'reservoir',          None),
    ('Ecology/TransmissionRoutes/transmission_route',     'transmission_route', None),
    ('ClinicalProfile/ClinicalRoles/clinical_role',       'role',               None),
    ('ClinicalProfile/TypicalSpecimens/typical_specimen', 'typical_specimen',   'mesh_anatomy_id'),
    ('ClinicalProfile/RiskContexts/risk_context',         'risk_context',       None),
    ('ClinicalProfile/BloomTriggers/bloom_trigger',       'bloom_trigger',      'kegg_drug_id'),
    ('ClinicalProfile/AmrHighlights/amr_highlight',          'amr_highlight',      'aro_id'),
    ('ClinicalProfile/VirulenceFactors/virulence_factor',    'virulence_factor',   'vfdb_id'),
]


def main():
    if len(sys.argv) < 2:
        print('Usage: python3 xml2sql.py <path/to/MCA_DB_*.xml>', file=sys.stderr)
        sys.exit(1)

    xml_path = sys.argv[1]
    out_path = os.path.splitext(xml_path)[0] + '.sql'
    today = date.today().isoformat()

    tree = ET.parse(xml_path)
    root = tree.getroot()

    lines = []

    def w(line=''):
        lines.append(line)

    # ── Header ──────────────────────────────────────────────────────────────
    w('-- MCA database dump')
    w(f'-- Source XML : {os.path.basename(xml_path)}')
    w(f'-- Generated  : {today}')
    w(f'-- Import     : mysql MCA < {os.path.basename(out_path)}')
    w()
    w('USE MCA;')
    w()
    w('SET FOREIGN_KEY_CHECKS = 0;')
    w()
    w('-- truncate all data tables before reload')
    for tbl in ('assoc_pmid', 'assoc_ref', 'association', 'passport_pmid',
                'metabolite', 'taxon_tag', 'biology', 'passport', 'paper'):
        w(f'TRUNCATE TABLE {tbl};')
    w()

    # ── meta ────────────────────────────────────────────────────────────────
    meta_el = root.find('Meta')
    if meta_el is not None:
        db_version = get_text(meta_el, 'version', 'unknown')
        w('-- meta')
        w(f"INSERT INTO meta (key_name, key_value) VALUES ('db_version', {esc(db_version)})")
        w(f"  ON DUPLICATE KEY UPDATE key_value = {esc(db_version)};")
        w()

    # ── papers ──────────────────────────────────────────────────────────────
    papers_el = root.find('Papers')
    if papers_el is not None:
        w('-- papers')
        for paper_el in papers_el.findall('Paper'):
            pmid         = esc_int(get_text(paper_el, 'pmid'))
            title        = esc(get_text(paper_el, 'title'))
            authors      = esc(get_text(paper_el, 'authors'))
            journal      = esc(get_text(paper_el, 'journal'))
            year         = esc_int(get_text(paper_el, 'year'))
            study_design = esc(get_text(paper_el, 'study_design'))
            population   = esc(get_text(paper_el, 'population'))
            sample_size  = esc_int(get_text(paper_el, 'sample_size'))
            if pmid != 'NULL':
                w(
                    f'INSERT INTO paper '
                    f'(pmid, title, authors, journal, year, study_design, population, sample_size) '
                    f'VALUES ({pmid}, {title}, {authors}, {journal}, {year}, '
                    f'{study_design}, {population}, {sample_size}) AS _new '
                    f'ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, '
                    f'journal=_new.journal, year=_new.year, '
                    f'study_design=_new.study_design, population=_new.population, '
                    f'sample_size=_new.sample_size;'
                )
        w()

    # ── passports ───────────────────────────────────────────────────────────
    passport_pk = {}   # passport_id string  → surrogate INT PK
    passport_counter = 1
    assoc_counter    = 1

    skipped_assocs = 0

    passports = root.findall('TaxonPassport')

    for tp in passports:
        pid_str = get_text(tp, 'passport_id')
        p_pk = passport_counter
        passport_pk[pid_str] = p_pk
        passport_counter += 1

        preferred_name = get_text(tp, 'preferred_name')
        taxon_rank     = get_text(tp, 'taxon_rank')
        domain         = get_text(tp, 'domain')
        lineage        = get_text(tp, 'lineage')
        ncbi_taxid     = get_text(tp, 'ncbi_taxid')
        is_pathobiont  = get_text(tp, 'is_pathobiont', 'unknown')
        last_reviewed  = get_text(tp, 'last_reviewed', today)
        created_at     = get_text(tp, 'created_at', today)
        updated_at     = get_text(tp, 'updated_at', today)

        # ── passport ──
        w(f'-- ── {pid_str}  {preferred_name}')
        w(
            f'INSERT INTO passport '
            f'(id, passport_id, preferred_name, taxon_rank, domain, lineage, '
            f'ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES ('
            f'{p_pk}, {esc(pid_str)}, {esc(preferred_name)}, {esc(taxon_rank)}, {esc(domain)}, '
            f'{esc(lineage)}, {esc_int(ncbi_taxid)}, {esc(is_pathobiont)}, '
            f'{esc(last_reviewed)}, {esc(created_at)}, {esc(updated_at)});'
        )
        w()

        # ── biology ──
        bio = tp.find('Biology')
        if bio is not None:
            gram        = get_text(bio, 'gram_status', 'unknown')
            oxy         = get_text(bio, 'oxygen_tolerance', 'unknown')
            morph       = get_text(bio, 'morphology')
            bacdive_url = get_text(bio, 'bacdive_url')
            w(
                f'INSERT INTO biology '
                f'(passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES ('
                f'{p_pk}, {esc(gram)}, {esc(oxy)}, {esc(morph)}, {esc(bacdive_url)}, {esc(created_at)}, {esc(updated_at)});'
            )
            w()

        # ── taxon_tag ──
        tag_rows = []
        for (xpath, category, attr) in TAG_SPECS:
            for el in tp.findall(xpath):
                val = el.text.strip() if el.text else None
                if not val:
                    continue
                ext = el.get(attr) if attr else None
                tag_rows.append((category, val, ext))

        if tag_rows:
            for (cat, val, ext) in tag_rows:
                w(
                    f'INSERT INTO taxon_tag '
                    f'(passport_id, category, value, ext_id, created_at, updated_at) VALUES ('
                    f'{p_pk}, {esc(cat)}, {esc(val)}, {esc(ext)}, {esc(created_at)}, {esc(updated_at)});'
                )
            w()

        # ── metabolites ──
        mets = tp.findall('Metabolites/Metabolite')
        for met in mets:
            mname  = get_text(met, 'metabolite_name')
            rel    = get_text(met, 'relationship', 'produces')
            kegg_c = get_text(met, 'kegg_compound_id')
            chebi  = get_text(met, 'chebi_id')
            if mname:
                w(
                    f'INSERT INTO metabolite '
                    f'(passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, '
                    f'created_at, updated_at) VALUES ('
                    f'{p_pk}, {esc(mname)}, {esc(rel)}, {esc(kegg_c)}, {esc(chebi)}, '
                    f'{esc(created_at)}, {esc(updated_at)});'
                )
        if mets:
            w()

        # ── passport_pmid ──
        pmid_els = tp.findall('TaxonEvidencePmids/pmid')
        for pmid_el in pmid_els:
            if pmid_el.text:
                w(
                    f'INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES ('
                    f'{p_pk}, {esc_int(pmid_el.text.strip())}, {esc(created_at)});'
                )
        if pmid_els:
            w()

        # ── associations ──
        assocs = tp.findall('ClinicalAssociations/ClinicalAssociation')
        for ca in assocs:
            assoc_text   = get_text(ca, 'association_text')
            content_hash = get_text(ca, 'content_hash')
            ev_grade     = get_text(ca, 'evidence_level')
            ev_type      = get_text(ca, 'evidence_type')

            if content_hash is None:
                print(
                    f'  WARNING: skipped association on {pid_str} — missing content_hash: '
                    f'{(assoc_text or "")[:70]}...',
                    file=sys.stderr,
                )
                skipped_assocs += 1
                continue

            if ev_grade is None:
                print(
                    f'  WARNING: missing evidence_level on {pid_str}, association: '
                    f'{(assoc_text or "")[:70]}... — skipping',
                    file=sys.stderr,
                )
                skipped_assocs += 1
                continue

            if ev_grade == 'UNCERTAIN':
                w(f'-- SKIPPED association (UNCERTAIN grade): {content_hash}')
                print(
                    f'  WARNING: skipped UNCERTAIN association on {pid_str}: '
                    f'{(assoc_text or "")[:70]}...',
                    file=sys.stderr,
                )
                skipped_assocs += 1
                continue

            a_pk = assoc_counter
            assoc_counter += 1

            w(
                f'INSERT INTO association '
                f'(id, passport_id, association_text, content_hash, evidence_level, evidence_type, '
                f'created_at, updated_at) VALUES ('
                f'{a_pk}, {p_pk}, {esc(assoc_text)}, {esc(content_hash)}, '
                f'{esc(ev_grade)}, {esc(ev_type)}, {esc(created_at)}, {esc(updated_at)});'
            )

            # Support both attribute-based <ref type="..." id="..." label="..."/>
            # and element-based <assoc_ref><ref_type>...</ref_type>...</assoc_ref>
            _refs = ca.findall('AssocRefs/ref') + ca.findall('AssocRefs/assoc_ref')
            for ref in _refs:
                ref_type  = ref.get('type')  or get_text(ref, 'ref_type')
                ref_id    = ref.get('id')    or get_text(ref, 'ref_id')
                ref_label = ref.get('label') or get_text(ref, 'ref_label')
                if ref_type and ref_id:
                    w(
                        f'INSERT INTO assoc_ref '
                        f'(association_id, ref_type, ref_id, ref_label, created_at) VALUES ('
                        f'{a_pk}, {esc(ref_type)}, {esc(ref_id)}, {esc(ref_label)}, {esc(created_at)});'
                    )

            for pmid_el in ca.findall('Pmids/pmid'):
                if pmid_el.text:
                    w(
                        f'INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES ('
                        f'{a_pk}, {esc_int(pmid_el.text.strip())}, {esc(created_at)});'
                    )

            w()

    # ── Footer ──────────────────────────────────────────────────────────────
    w('SET FOREIGN_KEY_CHECKS = 1;')
    w()
    n_passports = passport_counter - 1
    n_assocs    = assoc_counter - 1
    w(f'-- {n_passports} passport(s), {n_assocs} association(s) written')
    if skipped_assocs:
        w(f'-- {skipped_assocs} association(s) skipped (UNCERTAIN grade — not in SQL ENUM)')

    with open(out_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')

    print(f'Written : {out_path}')
    print(f'  Passports    : {n_passports}')
    print(f'  Associations : {n_assocs}')
    if skipped_assocs:
        print(f'  Skipped      : {skipped_assocs} (UNCERTAIN grade)')


if __name__ == '__main__':
    main()
