#!/usr/bin/env python3
"""
amr_kegg_enrich.py — Targeted enrichment of ARO IDs and KEGG Drug IDs in MCA XML.

Applies the following confirmed ext_id assignments:

  AMR highlights:
    MCA-BAC-000006 (Clostridioides difficile)
      "multidrug-resistant (MDR)"  → aro_id = ARO:3004305
      (ARO:3004305 = "multidrug resistance antimicrobial phenotype", CARD ARO OBO)

  Bloom triggers:
    MCA-BAC-000022 (Porphyromonas gingivalis)
      "proton pump inhibitor (PPI) use"  → kegg_drug_id = D00455
      (D00455 = omeprazole; representative PPI — no D-number for the drug class itself)

All other amr_highlights and bloom_triggers remain unenriched (no applicable IDs):
  - "intrinsic glycopeptide resistance" on Akkermansia, Bifidobacterium, L. rhamnosus:
    ARO covers acquired resistance genes and pathogen-specific phenotypes;
    structural/intrinsic insensitivity in commensals has no ARO phenotype term.
  - "unknown" amr_highlights: sentinel, no ID.
  - Remaining bloom_triggers (antibiotic exposure, hospitalization, dysbiosis, etc.):
    clinical states / drug-class concepts — no KEGG Drug D-numbers exist.

Usage:
    python3 database/amr_kegg_enrich.py [path/to/MCA_DB_vX_X_YYYYMMDD.xml]

If no argument is given, the most recent MCA_DB_v*.xml in database/ is used.
"""

import sys
import os
import json
import glob
import re
from datetime import date
import xml.etree.ElementTree as ET

SCRIPT_DIR   = os.path.dirname(os.path.abspath(__file__))
CURATION_LOG = os.path.join(SCRIPT_DIR, 'curation_log.json')

# Targeted patches: (passport_id, element_tag, text_value, attr_name, attr_value)
PATCHES = [
    # C. difficile MDR → ARO:3004305
    ('MCA-BAC-000006', 'amr_highlight',  'multidrug-resistant (MDR)',          'aro_id',       'ARO:3004305'),
    # P. gingivalis PPI bloom trigger → D00455 (omeprazole, representative PPI)
    ('MCA-BAC-000022', 'bloom_trigger',  'proton pump inhibitor (PPI) use',    'kegg_drug_id', 'D00455'),
]


def indent(elem, level=0):
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
    today = date.today().strftime('%Y%m%d')
    basename = os.path.basename(xml_path)
    m = re.match(r'MCA_DB_v(\d+)_(\d+)_(\d+)\.xml$', basename)
    if not m:
        raise ValueError(f'Unexpected filename format: {basename}')
    major, minor = int(m.group(1)), int(m.group(2))
    out_name = f'MCA_DB_v{major}_{minor + 1}_{today}.xml'
    return os.path.join(os.path.dirname(xml_path), out_name)


def main():
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
    print()

    tree = ET.parse(xml_path)
    root = tree.getroot()

    # Update version in <Meta>
    out_basename = os.path.basename(out_path)
    new_version = re.sub(r'MCA_DB_(v\d+_\d+_\d+)\.xml$', r'\1', out_basename)
    meta_version = root.find('Meta/version')
    if meta_version is not None:
        meta_version.text = new_version

    # Build lookup: passport_id → TaxonPassport element
    passport_map = {}
    for p in root.findall('TaxonPassport'):
        pid = p.findtext('passport_id', '').strip()
        if pid:
            passport_map[pid] = p

    log_entries = []
    applied = 0

    for (pid, elem_tag, text_val, attr_name, attr_val) in PATCHES:
        passport = passport_map.get(pid)
        if passport is None:
            print(f'  WARN  {pid} not found — skipping patch', file=sys.stderr)
            continue

        # Search all descendants with the right tag
        target = None
        for el in passport.iter(elem_tag):
            if el.text and el.text.strip() == text_val:
                target = el
                break

        if target is None:
            print(f'  WARN  {pid}: <{elem_tag}> with text {text_val!r} not found — skipping')
            continue

        existing = target.get(attr_name, '')
        if existing:
            print(f'  SKIP  {pid}: {elem_tag} {text_val!r} already has {attr_name}={existing!r}')
            continue

        target.set(attr_name, attr_val)
        applied += 1
        print(f'  SET   {pid}: <{elem_tag}> {text_val!r}  {attr_name}={attr_val!r}')

        log_entries.append({
            'passport_id':  pid,
            'element':      elem_tag,
            'value':        text_val,
            'attribute':    attr_name,
            'attr_value':   attr_val,
            'action':       'ENRICH_EXT_ID',
            'xml_file':     out_basename,
            'source':       'amr_kegg_enrich.py',
            'date':         date.today().isoformat(),
        })

    if applied == 0:
        print('No patches applied — nothing to write.')
        return

    # Pretty-print and write
    indent(root)
    tree.write(out_path, encoding='unicode', xml_declaration=True)

    with open(out_path, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(
        "<?xml version='1.0' encoding='us-ascii'?>",
        '<?xml version="1.0" encoding="UTF-8"?>'
    ).replace(
        "<?xml version='1.0' encoding='utf-8'?>",
        '<?xml version="1.0" encoding="UTF-8"?>'
    )
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(content)

    # Web copy
    web_copy = os.path.join(os.path.dirname(SCRIPT_DIR), 'web', 'data', 'MCA_DB_latest.xml')
    if os.path.isdir(os.path.dirname(web_copy)):
        import shutil
        shutil.copy2(out_path, web_copy)
        print(f'\nWeb copy updated: {web_copy}')

    # Curation log
    if log_entries and os.path.exists(CURATION_LOG):
        with open(CURATION_LOG, encoding='utf-8') as f:
            log = json.load(f)
        log.extend(log_entries)
        with open(CURATION_LOG, 'w', encoding='utf-8') as f:
            json.dump(log, f, indent=2, ensure_ascii=False)
        print(f'Curation log updated: {len(log_entries)} entries added.')

    print()
    print('=== Enrichment summary ===')
    print(f'  Patches applied : {applied}')
    print()
    print(f'Next step: python3 database/xml2sql.py {out_path}')


if __name__ == '__main__':
    main()
