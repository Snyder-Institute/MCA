#!/usr/bin/env python3
"""
build_ios_index.py — Subset kegg_brite_index.json for iOS app bundle.

Reads the full KEGG BRITE index and outputs a trimmed version containing
only entries reachable from MCA passport IDs.

Usage:
    python3 database/build_ios_index.py web/data/kegg_brite_index.json iOS/MCA/kegg_pathway_index.json
"""

import json
import sys
import os


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <input.json> [output.json]")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else "kegg_pathway_index.json"

    with open(input_path) as f:
        data = json.load(f)

    # 1. Collect MCA-reachable IDs

    passport_ids = set(data.get("passport_names", {}).keys())

    reachable_pathways = set()
    for pid, pways in data.get("passport_to_pathways", {}).items():
        reachable_pathways.update(pways)
    reachable_pathways.update(data.get("pathway_to_passports", {}).keys())

    pathway_base_ids = {p.split("(")[0] for p in reachable_pathways}

    reachable_diseases = set()
    for pid, kegg in data.get("passport_kegg", {}).items():
        reachable_diseases.update(kegg.get("diseases", {}).keys())
    for pway_id, diseases in data.get("pathway_to_diseases", {}).items():
        if pway_id in reachable_pathways:
            reachable_diseases.update(diseases)
    for nt_id, diseases in data.get("nt_to_diseases", {}).items():
        if nt_id in reachable_pathways:
            reachable_diseases.update(diseases)

    reachable_compounds = set()
    for pid, kegg in data.get("passport_kegg", {}).items():
        reachable_compounds.update(kegg.get("compounds", {}).keys())

    reachable_drugs = set()
    for pid, kegg in data.get("passport_kegg", {}).items():
        reachable_drugs.update(kegg.get("drugs", {}).keys())

    # 2. Build subset

    subset = {
        "pathways": {
            pid: info for pid, info in data.get("pathways", {}).items()
            if pid in reachable_pathways or pid.split("(")[0] in pathway_base_ids
        },
        "disease_names": {
            k: v for k, v in data.get("disease_names", {}).items()
            if k in reachable_diseases
        },
        "disease_to_pathways": {
            k: v for k, v in data.get("disease_to_pathways", {}).items()
            if k in reachable_diseases
        },
        "disease_to_nt": {
            k: v for k, v in data.get("disease_to_nt", {}).items()
            if k in reachable_diseases
        },
        "nt_to_diseases": {
            nt_id: [d for d in diseases if d in reachable_diseases]
            for nt_id, diseases in data.get("nt_to_diseases", {}).items()
            if nt_id in reachable_pathways
        },
        "pathway_to_diseases": {
            pid: [d for d in diseases if d in reachable_diseases]
            for pid, diseases in data.get("pathway_to_diseases", {}).items()
            if pid in reachable_pathways
        },
        "pathway_to_compounds": {
            pid: [c for c in compounds if c in reachable_compounds]
            for pid, compounds in data.get("pathway_to_compounds", {}).items()
            if pid in reachable_pathways
        },
        "compound_to_pathways": {
            cid: paths for cid, paths in data.get("compound_to_pathways", {}).items()
            if cid in reachable_compounds
        },
        "compound_names": {
            k: v for k, v in data.get("compound_names", {}).items()
            if k in reachable_compounds
        },
        "drug_names": {
            k: v for k, v in data.get("drug_names", {}).items()
            if k in reachable_drugs
        },
        "drug_class": {
            k: v for k, v in data.get("drug_class", {}).items()
            if k in reachable_drugs
        },
        "inf_class": {
            k: v for k, v in data.get("inf_class", {}).items()
            if k in reachable_diseases
        },
        "passport_kegg": data.get("passport_kegg", {}),
        "passport_names": data.get("passport_names", {}),
        "passport_to_pathways": data.get("passport_to_pathways", {}),
        "pathway_to_passports": data.get("pathway_to_passports", {}),
        "passport_cooccurrence": data.get("passport_cooccurrence", {}),
    }

    with open(output_path, "w") as f:
        json.dump(subset, f, separators=(",", ":"), ensure_ascii=False)

    input_size = os.path.getsize(input_path)
    output_size = os.path.getsize(output_path)
    print(f"Input:  {input_path} ({input_size:,} bytes)")
    print(f"Output: {output_path} ({output_size:,} bytes)")
    print(f"Reduction: {(1 - output_size / input_size) * 100:.1f}%")
    print()
    for k in sorted(subset.keys()):
        print(f"  {k}: {len(subset[k])} entries")


if __name__ == "__main__":
    main()
