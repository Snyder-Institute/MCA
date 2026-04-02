#!/usr/bin/env python3
"""
vfdb_backfill.py — Backfill VirulenceFactors into existing MCA XML passports.

Reads the current MCA XML, looks up each taxon in the local VFDB JSON mirror,
inserts <VirulenceFactors> blocks into <ClinicalProfile>, writes a new versioned
XML file, and logs the operation to curation_log.json.

Usage:
    python3 database/vfdb_backfill.py [path/to/MCA_DB_vX_X_YYYYMMDD.xml]

If no argument is given, the most recent MCA_DB_v*.xml in database/ is used.
"""

import sys
import os
import json
import glob
import re
from datetime import date
import xml.etree.ElementTree as ET

# ── Paths ──────────────────────────────────────────────────────────────────
VFDB_JSON = (
    '/Users/heewon.seo/Library/CloudStorage/'
    'Dropbox-BioinformaticsHub/Projects/mca/vfdb/vfdb.json'
)
SCRIPT_DIR    = os.path.dirname(os.path.abspath(__file__))
CURATION_LOG  = os.path.join(SCRIPT_DIR, 'curation_log.json')

# ── Taxon → VFDB key mapping ───────────────────────────────────────────────
# Maps MCA preferred_name (lowercase) → list of vfdb.json keys to union.
# Handles multi-pathotype organisms (E. coli, Salmonella) and renamed taxa (C. diff).
MCA_VFDB_MAP = {
    'clostridioides difficile':     ['clostridioides difficile'],
    'bacteroides fragilis':         ['bacteroides fragilis'],
    'bacteroides thetaiotaomicron': ['bacteroides thetaiotaomicron'],
    'helicobacter pylori':          ['helicobacter pylori'],
    'campylobacter jejuni':         ['campylobacter jejuni'],
    'salmonella enterica':          [
        'salmonella enterica (serovar typhi)',
        'salmonella enterica (serovar typhimurium)',
    ],
    'escherichia coli':             None,   # resolved at runtime: all keys starting with 'escherichia coli'
    'klebsiella pneumoniae':        ['klebsiella pneumoniae'],
    'pseudomonas aeruginosa':       ['pseudomonas aeruginosa'],
    'staphylococcus aureus':        ['staphylococcus aureus'],
    'streptococcus pyogenes':       ['streptococcus pyogenes'],
    'streptococcus pneumoniae':     ['streptococcus pneumoniae'],
    'streptococcus agalactiae':     ['streptococcus agalactiae'],
    'enterococcus faecalis':        ['enterococcus faecalis'],
    'enterococcus faecium':         ['enterococcus faecium'],
    'listeria monocytogenes':       ['listeria monocytogenes'],
    'mycobacterium tuberculosis':   ['mycobacterium tuberculosis'],
    'clostridium perfringens':      ['clostridium perfringens'],
}


def load_vfdb(path):
    with open(path, encoding='utf-8') as f:
        data = json.load(f)
    # resolve runtime wildcard for E. coli
    ecoli_keys = sorted(k for k in data if k.startswith('escherichia coli'))
    MCA_VFDB_MAP['escherichia coli'] = ecoli_keys
    return data


def get_vfs_for_taxon(preferred_name, vfdb):
    """Return deduplicated list of VF dicts for a given taxon preferred_name."""
    keys = MCA_VFDB_MAP.get(preferred_name.lower())
    if not keys:
        return []
    vfs = []
    for k in keys:
        vfs.extend(vfdb.get(k, []))
    # deduplicate by vfid, preserving order
    seen = set()
    unique = []
    for v in vfs:
        if v['vfid'] not in seen:
            seen.add(v['vfid'])
            unique.append(v)
    return unique


def indent(elem, level=0):
    """Add pretty-print indentation to an ElementTree element (in-place)."""
    pad = '\n' + '  ' * level
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = pad + '  '
        if not elem.tail or not elem.tail.strip():
            elem.tail = pad
        for child in elem:
            indent(child, level + 1)
        if not child.tail or not child.tail.strip():
            child.tail = pad
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = pad
    if not level:
        elem.tail = '\n'


def bump_version(xml_path):
    """Derive the output path by bumping MINOR version and using today's date."""
    today = date.today().strftime('%Y%m%d')
    basename = os.path.basename(xml_path)
    # match vMAJOR_MINOR_DATE
    m = re.match(r'MCA_DB_v(\d+)_(\d+)_(\d+)\.xml$', basename)
    if not m:
        raise ValueError(f'Unexpected filename format: {basename}')
    major, minor = int(m.group(1)), int(m.group(2))
    out_name = f'MCA_DB_v{major}_{minor + 1}_{today}.xml'
    return os.path.join(os.path.dirname(xml_path), out_name)


def main():
    # ── Locate input XML ───────────────────────────────────────────────────
    if len(sys.argv) >= 2:
        xml_path = sys.argv[1]
    else:
        candidates = sorted(glob.glob(os.path.join(SCRIPT_DIR, 'MCA_DB_v*.xml')))
        if not candidates:
            print('ERROR: No MCA_DB_v*.xml found in database/', file=sys.stderr)
            sys.exit(1)
        xml_path = candidates[-1]

    out_path = bump_version(xml_path)

    print(f'Input : {xml_path}')
    print(f'Output: {out_path}')
    print(f'VFDB  : {VFDB_JSON}')
    print()

    # ── Load VFDB ─────────────────────────────────────────────────────────
    if not os.path.exists(VFDB_JSON):
        print(f'ERROR: VFDB JSON not found at {VFDB_JSON}', file=sys.stderr)
        sys.exit(1)
    vfdb = load_vfdb(VFDB_JSON)

    # ── Parse XML ─────────────────────────────────────────────────────────
    ET.register_namespace('', '')
    tree = ET.parse(xml_path)
    root = tree.getroot()

    # ── Update version in <Meta> ───────────────────────────────────────────
    out_basename = os.path.basename(out_path)
    new_version = re.sub(r'MCA_DB_(v\d+_\d+_\d+)\.xml$', r'\1', out_basename)
    meta_version = root.find('Meta/version')
    if meta_version is not None:
        meta_version.text = new_version

    # ── Process each TaxonPassport ─────────────────────────────────────────
    stats = {'matched': 0, 'skipped_no_vfdb': 0, 'skipped_already_has_vf': 0, 'total_vfs': 0}
    log_entries = []

    for passport in root.findall('TaxonPassport'):
        name_el = passport.find('preferred_name')
        pid_el  = passport.find('passport_id')
        if name_el is None:
            continue

        preferred_name = name_el.text.strip()
        passport_id    = pid_el.text.strip() if pid_el is not None else 'unknown'

        vfs = get_vfs_for_taxon(preferred_name, vfdb)
        if not vfs:
            stats['skipped_no_vfdb'] += 1
            continue

        # Find or create <ClinicalProfile>
        cp = passport.find('ClinicalProfile')
        if cp is None:
            cp = ET.SubElement(passport, 'ClinicalProfile')

        # Skip if VirulenceFactors already present
        if cp.find('VirulenceFactors') is not None:
            print(f'  SKIP  {passport_id}  {preferred_name}  (VirulenceFactors already present)')
            stats['skipped_already_has_vf'] += 1
            continue

        # Build <VirulenceFactors> element
        vf_el = ET.SubElement(cp, 'VirulenceFactors')
        for vf in vfs:
            child = ET.SubElement(vf_el, 'virulence_factor')
            child.text = vf['vf_name']
            child.set('vfdb_id', vf['vfid'])

        stats['matched'] += 1
        stats['total_vfs'] += len(vfs)
        print(f'  ADD   {passport_id}  {preferred_name}  ({len(vfs)} VFs)')

        log_entries.append({
            'passport_id':  passport_id,
            'preferred_name': preferred_name,
            'action':       'BACKFILL_VFDB',
            'vf_count':     len(vfs),
            'xml_file':     out_basename,
            'source':       'vfdb_backfill.py',
            'date':         date.today().isoformat(),
        })

    # ── Pretty-print and write XML ─────────────────────────────────────────
    indent(root)
    tree.write(out_path, encoding='unicode', xml_declaration=True)

    # Fix xml declaration encoding line (ElementTree writes encoding="us-ascii" sometimes)
    with open(out_path, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(
        "<?xml version='1.0' encoding='us-ascii'?>",
        '<?xml version="1.0" encoding="UTF-8"?>'
    ).replace(
        '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
        '<?xml version="1.0" encoding="UTF-8"?>'
    )
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(content)

    # ── Also write web copy ─────────────────────────────────────────────────
    web_copy = os.path.join(os.path.dirname(SCRIPT_DIR), 'web', 'data', 'MCA_DB_latest.xml')
    if os.path.isdir(os.path.dirname(web_copy)):
        import shutil
        shutil.copy2(out_path, web_copy)
        print(f'\nWeb copy updated: {web_copy}')

    # ── Update curation_log.json ───────────────────────────────────────────
    if log_entries and os.path.exists(CURATION_LOG):
        with open(CURATION_LOG, encoding='utf-8') as f:
            log = json.load(f)
        log.extend(log_entries)
        with open(CURATION_LOG, 'w', encoding='utf-8') as f:
            json.dump(log, f, indent=2, ensure_ascii=False)
        print(f'Curation log updated: {len(log_entries)} entries added.')

    # ── Summary ────────────────────────────────────────────────────────────
    print()
    print('=== Backfill summary ===')
    print(f'  Passports enriched  : {stats["matched"]}')
    print(f'  Total VFs added     : {stats["total_vfs"]}')
    print(f'  No VFDB match       : {stats["skipped_no_vfdb"]}')
    print(f'  Already had VFs     : {stats["skipped_already_has_vf"]}')
    print()
    print(f'Next step: python3 database/xml2sql.py {out_path}')


if __name__ == '__main__':
    main()
