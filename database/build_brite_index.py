#!/usr/bin/env python3
"""
build_brite_index.py — Build KEGG BRITE pathway index for MCA pathway search.

Reads KEGG flat files and BRITE hierarchy files, then writes
web/data/kegg_brite_index.json for use by web/search.php and
web/ajax_pathway.php.

Usage (run from MCA project root):
    python3 database/build_brite_index.py

Output:
    web/data/kegg_brite_index.json
"""

import json
import os
import re
import glob
import xml.etree.ElementTree as ET

# ── Paths ─────────────────────────────────────────────────────────────────────

KEGG_BASE = os.path.expanduser(
    "~/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/kegg"
)

DISEASE_FILE  = os.path.join(KEGG_BASE, "medicus/disease/disease")
DRUG_FILE     = os.path.join(KEGG_BASE, "medicus/drug/drug")
COMPOUND_FILE = os.path.join(KEGG_BASE, "ligand/compound/compound")

BRITE_BR          = os.path.join(KEGG_BASE, "brite/br")
BRITE_PATHWAY_MAP = os.path.join(BRITE_BR, "br08901.keg")   # pathway names
BRITE_DISEASE_PATH= os.path.join(BRITE_BR, "br08402.keg")   # nt-pathway → H disease
BRITE_DRUG_TARGET = os.path.join(BRITE_BR, "br08310.keg")   # drug target classes
BRITE_INFECTIOUS  = os.path.join(BRITE_BR, "br08401.keg")   # infectious disease classification

# Resolve latest MCA XML
_xml_candidates = sorted(glob.glob("database/MCA_DB_v*.xml"))
MCA_XML = _xml_candidates[-1] if _xml_candidates else None

OUT_PATH = "web/data/kegg_brite_index.json"


# ── Parsers ───────────────────────────────────────────────────────────────────

def parse_pathway_names(keg_path):
    """br08901.keg → {map#####: {id, name, category, subcategory}}"""
    pathways = {}
    category = subcategory = None
    with open(keg_path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('A'):
                category = re.sub(r'<[^>]+>', '', line[1:]).strip()
                subcategory = None
            elif line.startswith('B'):
                subcategory = line[2:].strip()
            elif line.startswith('C'):
                m = re.match(r'C\s+(\d{5})\s+(.*)', line)
                if m:
                    num, name = m.group(1), m.group(2).strip()
                    entry = {
                        "id":          f"map{num}",
                        "name":        name,
                        "category":    category or "",
                        "subcategory": subcategory or "",
                    }
                    pathways[f"map{num}"] = entry
                    pathways[f"hsa{num}"] = dict(entry, id=f"hsa{num}")
    return pathways


def parse_br08402(keg_path):
    """
    br08402.keg (pathway-based disease classification)
    Returns:
        nt_names       : {nt######: {id, name, category}}
        nt_to_diseases : {nt######: [H#####, ...]}
        disease_to_nt  : {H#####: [nt######, ...]}
    """
    nt_names = {}
    nt_to_diseases = {}
    disease_to_nt = {}
    category = current_nt = None
    with open(keg_path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('A'):
                category = line[1:].strip()
            elif line.startswith('B'):
                m = re.match(r'B\s+(nt\d+)\s+(.*)', line)
                if m:
                    current_nt = m.group(1)
                    nt_names[current_nt] = {
                        "id":       current_nt,
                        "name":     m.group(2).strip(),
                        "category": category or "",
                    }
                    nt_to_diseases.setdefault(current_nt, [])
            elif line.startswith('C') and current_nt:
                m = re.match(r'C\s+(H\d+)\s+', line)
                if m:
                    hid = m.group(1)
                    if hid not in nt_to_diseases[current_nt]:
                        nt_to_diseases[current_nt].append(hid)
                    disease_to_nt.setdefault(hid, [])
                    if current_nt not in disease_to_nt[hid]:
                        disease_to_nt[hid].append(current_nt)
    return nt_names, nt_to_diseases, disease_to_nt


def parse_br08401(keg_path):
    """
    br08401.keg (infectious disease classification)
    Returns {H#####: {category, subcategory}}
    """
    inf_class = {}
    category = subcategory = None
    with open(keg_path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('A'):
                category = line[1:].strip()
                subcategory = None
            elif line.startswith('B'):
                subcategory = line[2:].strip()
            elif line.startswith('C'):
                m = re.match(r'C\s+(H\d+)\s+', line)
                if m:
                    inf_class[m.group(1)] = {
                        "category":    category or "",
                        "subcategory": subcategory or "",
                    }
    return inf_class


def parse_br08310(keg_path):
    """
    br08310.keg (target-based drug classification)
    Returns {D#####: {target_class, target_family}}
    """
    drug_class = {}
    current_a = current_b = None
    with open(keg_path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('A'):
                current_a = re.sub(r'<[^>]+>', '', line[1:]).strip()
                current_b = None
            elif line.startswith('B'):
                current_b = line[2:].strip()
            elif line.startswith('E'):
                m = re.match(r'E\s+(D\d+)\s+', line)
                if m:
                    drug_class[m.group(1)] = {
                        "target_class":  current_a or "",
                        "target_family": current_b or "",
                    }
    return drug_class


def parse_flat_file(filepath):
    """
    Parse a KEGG flat file (disease / drug / compound).
    Yields dicts: {id, name, pathways: [(pid, pname), ...]}
    Entries are delimited by '///'.
    """
    current_id = current_name = None
    current_pathways = []
    name_set = False

    with open(filepath, encoding='utf-8', errors='replace') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('ENTRY'):
                m = re.match(r'ENTRY\s+(\S+)', line)
                current_id = m.group(1) if m else None
                current_name = None
                current_pathways = []
                name_set = False
            elif line.startswith('NAME') and not name_set:
                current_name = line[4:].strip().rstrip(';')
                name_set = True
            elif line.startswith('PATHWAY') or line.startswith('DIS_PATHWAY'):
                m = re.match(r'(?:DIS_)?PATHWAY\s+(\S+)\s+(.*)', line)
                if m:
                    current_pathways.append((m.group(1), m.group(2).strip()))
            elif line.startswith('///'):
                if current_id:
                    yield {
                        'id':       current_id,
                        'name':     current_name or '',
                        'pathways': current_pathways,
                    }
                current_id = current_name = None
                current_pathways = []
                name_set = False
    if current_id:
        yield {'id': current_id, 'name': current_name or '', 'pathways': current_pathways}


def parse_mca_xml(xml_path):
    """
    Parse MCA XML → per-passport KEGG IDs.
    Returns:
        passport_kegg  : {passport_id: {diseases:{H:label}, drugs:{D:name}, compounds:{C:name}}}
        passport_names : {passport_id: preferred_name}
    """
    tree = ET.parse(xml_path)
    root = tree.getroot()
    passport_kegg = {}
    passport_names = {}

    for tp in root.findall('TaxonPassport'):
        pid  = (tp.findtext('passport_id') or '').strip()
        name = (tp.findtext('preferred_name') or '').strip()
        if not pid:
            continue
        passport_names[pid] = name
        passport_kegg[pid] = {'diseases': {}, 'drugs': {}, 'compounds': {}}

        # KEGG Disease IDs from clinical association refs
        for ca in tp.findall('ClinicalAssociations/ClinicalAssociation'):
            for ref in ca.findall('AssocRefs/ref') + ca.findall('AssocRefs/assoc_ref'):
                rtype  = (ref.get('type')  or (ref.findtext('ref_type')  or '')).strip()
                rid    = (ref.get('id')    or (ref.findtext('ref_id')    or '')).strip()
                rlabel = (ref.get('label') or (ref.findtext('ref_label') or '')).strip()
                if rtype == 'kegg_disease' and rid:
                    passport_kegg[pid]['diseases'][rid] = rlabel

        # KEGG Drug IDs from bloom triggers
        for bt in tp.findall('ClinicalProfile/BloomTriggers/bloom_trigger'):
            did  = (bt.get('kegg_drug_id') or '').strip()
            dname = (bt.text or '').strip()
            if did:
                passport_kegg[pid]['drugs'][did] = dname

        # KEGG Compound IDs from metabolites
        for met in tp.findall('Metabolites/Metabolite'):
            cid   = (met.findtext('kegg_compound_id') or '').strip()
            cname = (met.findtext('metabolite_name')  or '').strip()
            if cid:
                passport_kegg[pid]['compounds'][cid] = cname

    return passport_kegg, passport_names


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if MCA_XML is None:
        print("ERROR: No database/MCA_DB_v*.xml found. Run from MCA project root.", flush=True)
        raise SystemExit(1)

    print(f"Building KEGG BRITE pathway index from {os.path.basename(MCA_XML)}...", flush=True)

    # ── 1. Pathway names (br08901) ─────────────────────────────────────────
    print("  Parsing pathway names (br08901.keg)...", flush=True)
    pathways = parse_pathway_names(BRITE_PATHWAY_MAP)

    # ── 2. nt-pathway → disease (br08402) ─────────────────────────────────
    print("  Parsing pathway-disease classification (br08402.keg)...", flush=True)
    nt_names, nt_to_diseases, disease_to_nt = parse_br08402(BRITE_DISEASE_PATH)
    pathways.update(nt_names)   # add nt entries to main pathway dict

    # ── 3. Infectious disease classification (br08401) ─────────────────────
    print("  Parsing infectious disease classification (br08401.keg)...", flush=True)
    inf_class = parse_br08401(BRITE_INFECTIOUS)

    # ── 4. Drug target classification (br08310) ───────────────────────────
    print("  Parsing drug target classification (br08310.keg)...", flush=True)
    drug_class = parse_br08310(BRITE_DRUG_TARGET)

    # ── 5. Disease flat file → names + hsa pathway links ──────────────────
    print("  Parsing disease flat file...", flush=True)
    disease_names      = {}
    disease_to_pathways = {}   # H → [hsa/map IDs]
    pathway_to_diseases = {}   # hsa/map → [H IDs]

    for e in parse_flat_file(DISEASE_FILE):
        hid = e['id']
        disease_names[hid] = e['name']
        pids = [p[0] for p in e['pathways']]
        if pids:
            disease_to_pathways[hid] = pids
            for pid in pids:
                pathway_to_diseases.setdefault(pid, [])
                if hid not in pathway_to_diseases[pid]:
                    pathway_to_diseases[pid].append(hid)

    # ── 6. Drug flat file → names ──────────────────────────────────────────
    print("  Parsing drug flat file...", flush=True)
    drug_names = {e['id']: e['name'] for e in parse_flat_file(DRUG_FILE)}

    # ── 7. Compound flat file → names + map pathway links ──────────────────
    print("  Parsing compound flat file...", flush=True)
    compound_names      = {}
    compound_to_pathways = {}   # C → [map IDs]
    pathway_to_compounds = {}   # map → [C IDs]

    for e in parse_flat_file(COMPOUND_FILE):
        cid = e['id']
        compound_names[cid] = e['name']
        pids = [p[0] for p in e['pathways']]
        if pids:
            compound_to_pathways[cid] = pids
            for pid in pids:
                pathway_to_compounds.setdefault(pid, [])
                if cid not in pathway_to_compounds[pid]:
                    pathway_to_compounds[pid].append(cid)

    # ── 8. MCA XML ──────────────────────────────────────────────────────────
    print(f"  Parsing MCA XML...", flush=True)
    passport_kegg, passport_names = parse_mca_xml(MCA_XML)

    # Collect all MCA-referenced KEGG IDs
    mca_disease_ids  = set()
    mca_drug_ids     = set()
    mca_compound_ids = set()
    for kegg in passport_kegg.values():
        mca_disease_ids.update(kegg['diseases'])
        mca_drug_ids.update(kegg['drugs'])
        mca_compound_ids.update(kegg['compounds'])

    # ── 9. Passport → pathways ─────────────────────────────────────────────
    print("  Building passport → pathway index...", flush=True)
    passport_to_pathways = {}   # passport_id → [pathway_ids]
    pathway_to_passports = {}   # pathway_id  → [passport_ids]

    for pid, kegg in passport_kegg.items():
        paths = set()
        # via disease → hsa pathways
        for hid in kegg['diseases']:
            paths.update(disease_to_pathways.get(hid, []))
            paths.update(disease_to_nt.get(hid, []))
        # via compound → map pathways
        for cid in kegg['compounds']:
            paths.update(compound_to_pathways.get(cid, []))
        if paths:
            passport_to_pathways[pid] = sorted(paths)
            for path in paths:
                pathway_to_passports.setdefault(path, [])
                if pid not in pathway_to_passports[path]:
                    pathway_to_passports[path].append(pid)

    # ── 10. Co-occurrence index ────────────────────────────────────────────
    print("  Building co-occurrence index...", flush=True)
    passport_cooccurrence = {}   # passport_id → {other_pid: shared_count}
    for pid, paths in passport_to_pathways.items():
        counts = {}
        for path in paths:
            for other in pathway_to_passports.get(path, []):
                if other != pid:
                    counts[other] = counts.get(other, 0) + 1
        if counts:
            passport_cooccurrence[pid] = counts

    # ── 11. Filter names to MCA-relevant only (keep index small) ───────────
    # Diseases: MCA-referenced + diseases in shared pathways
    mca_relevant_pathways = set()
    for paths in passport_to_pathways.values():
        mca_relevant_pathways.update(paths)

    related_disease_ids = set(mca_disease_ids)
    for path in mca_relevant_pathways:
        related_disease_ids.update(pathway_to_diseases.get(path, []))
        related_disease_ids.update(nt_to_diseases.get(path, []))

    disease_names_out  = {k: v for k, v in disease_names.items()  if k in related_disease_ids}
    drug_names_out     = {k: v for k, v in drug_names.items()     if k in mca_drug_ids}
    compound_names_out = {k: v for k, v in compound_names.items() if k in mca_compound_ids}

    # Filter pathway_to_diseases and pathway_to_compounds to MCA-relevant pathways
    pathway_to_diseases_out  = {k: v for k, v in pathway_to_diseases.items()  if k in mca_relevant_pathways}
    pathway_to_compounds_out = {k: v for k, v in pathway_to_compounds.items() if k in mca_relevant_pathways}
    nt_to_diseases_out       = {k: v for k, v in nt_to_diseases.items()       if k in mca_relevant_pathways}

    # ── 12. Assemble index ─────────────────────────────────────────────────
    index = {
        "pathways":              pathways,
        "disease_to_pathways":   disease_to_pathways,
        "pathway_to_diseases":   pathway_to_diseases_out,
        "disease_to_nt":         disease_to_nt,
        "nt_to_diseases":        nt_to_diseases_out,
        "compound_to_pathways":  compound_to_pathways,
        "pathway_to_compounds":  pathway_to_compounds_out,
        "disease_names":         disease_names_out,
        "drug_names":            drug_names_out,
        "compound_names":        compound_names_out,
        "drug_class":            drug_class,
        "inf_class":             inf_class,
        "passport_kegg":         passport_kegg,
        "passport_names":        passport_names,
        "passport_to_pathways":  passport_to_pathways,
        "pathway_to_passports":  pathway_to_passports,
        "passport_cooccurrence": passport_cooccurrence,
    }

    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, 'w', encoding='utf-8') as f:
        json.dump(index, f, ensure_ascii=False, separators=(',', ':'))

    size_kb = os.path.getsize(OUT_PATH) / 1024
    print(f"\nWritten : {OUT_PATH} ({size_kb:.1f} KB)", flush=True)
    print(f"  map/hsa pathways indexed    : {len(pathways)}")
    print(f"  nt network pathways indexed : {len(nt_names)}")
    print(f"  Diseases with hsa pathways  : {len(disease_to_pathways)}")
    print(f"  Compounds with map pathways : {len(compound_to_pathways)}")
    print(f"  Passports with pathways     : {len(passport_to_pathways)}")
    print(f"  MCA-relevant pathway IDs    : {len(mca_relevant_pathways)}")
    print(f"  Related disease names kept  : {len(disease_names_out)}")


if __name__ == '__main__':
    main()
