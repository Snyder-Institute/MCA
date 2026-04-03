"""
fetch_bacdive.py — Build a local BacDive cache for MCA taxa.

Reads the current MCA XML, looks up each taxon on BacDive, fetches all strain
records, and writes a JSON cache keyed by ncbi_taxid.

Output: Dropbox mca/bacdive/bacdive_cache.json

Usage:
    python3 database/fetch_bacdive.py [--force]

    --force   Re-fetch taxa already present in the cache (default: skip them)

Query strategy (3-pass, stops at first hit):
    1. NCBI TaxID  → GET /search?s[ncbi_tax_id]={taxid}
    2. Preferred name → GET /taxon/{genus}/{species} or /taxon/{genus}
    3. Synonyms (each) → GET /taxon/{genus}/{species} until a hit

BacDive API base: https://api.bacdive.dsmz.de  (no /v2/ prefix)
  - /search?s[ncbi_tax_id]={taxid} → list of BacDive strain IDs by NCBI TaxID
  - /taxon/{genus}/                → list of BacDive strain IDs for a genus
  - /taxon/{genus}/{species}       → list of BacDive strain IDs for a species
  - /fetch/{id}                    → full strain record JSON
"""

import json
import time
import sys
import ssl
import certifi
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError

SSL_CTX = ssl.create_default_context(cafile=certifi.where())

# ── Config ──────────────────────────────────────────────────────────────────
OUT_PATH    = Path("/Users/heewon.seo/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/bacdive/bacdive_cache.json")
BASE_URL    = "https://api.bacdive.dsmz.de"
PAUSE       = 0.4   # seconds between API calls
FETCH_LIMIT = 10    # max strain records to fetch per taxon (type strains first)


def latest_xml() -> Path:
    """Return the most recently modified MCA_DB_v*.xml in database/."""
    candidates = sorted(
        Path("database").glob("MCA_DB_v*.xml"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    if not candidates:
        print("ERROR: no MCA_DB_v*.xml found in database/")
        sys.exit(1)
    return candidates[0]


# ── Helpers ──────────────────────────────────────────────────────────────────
def api_get(path: str) -> dict | None:
    url = BASE_URL + path
    try:
        req = Request(url, headers={"Accept": "application/json"})
        with urlopen(req, timeout=15, context=SSL_CTX) as r:
            return json.loads(r.read().decode())
    except HTTPError as e:
        print(f"  HTTP {e.code}: {url}")
        return None
    except (URLError, Exception) as e:
        print(f"  ERROR: {url} — {e}")
        return None


def extract_ids(data: dict | None) -> list[int]:
    if not data:
        return []
    results = data.get("results", [])
    if isinstance(results, list):
        return [r for r in results if isinstance(r, int)]
    return []


def get_ids_by_taxid(taxid: str) -> list[int]:
    data = api_get(f"/search?s[ncbi_tax_id]={taxid}")
    time.sleep(PAUSE)
    return extract_ids(data)


def get_ids_by_name(genus: str, species: str | None) -> list[int]:
    path = f"/taxon/{genus}/{species}" if species else f"/taxon/{genus}"
    data = api_get(path)
    time.sleep(PAUSE)
    return extract_ids(data)


def parse_name(name: str) -> tuple[str, str | None]:
    """Split 'Genus species [subsp. ...]' into (genus, species_epithet | None)."""
    parts = name.split()
    if len(parts) >= 2:
        return parts[0], parts[1]
    return parts[0], None


def fetch_strain(strain_id: int) -> dict | None:
    data = api_get(f"/fetch/{strain_id}")
    time.sleep(PAUSE)
    if not data:
        return None
    results = data.get("results", {})
    if str(strain_id) in results:
        return results[str(strain_id)]
    if strain_id in results:
        return results[strain_id]
    if results:
        return next(iter(results.values()))
    return None


def is_type_strain(record: dict) -> bool:
    """Return True if the strain record is a designated type strain."""
    # BacDive v2 marks type strains under taxonomy_name or name_and_taxonomic_classification
    for key in ("taxonomy_name", "name_and_taxonomic_classification"):
        block = record.get(key, {})
        if isinstance(block, dict):
            val = block.get("is_type_strain") or block.get("type_strain")
            if val and str(val).lower() not in ("no", "false", "0", ""):
                return True
    return False


# ── Main ─────────────────────────────────────────────────────────────────────
def main():
    force = "--force" in sys.argv

    xml_path = latest_xml()
    print(f"Reading {xml_path} ...")
    tree = ET.parse(xml_path)
    root = tree.getroot()

    taxa = []
    for tp in root.findall("TaxonPassport"):
        synonyms = [
            el.text.strip()
            for el in tp.findall("Synonyms/synonym")
            if el.text and el.text.strip()
        ]
        taxa.append({
            "passport_id":    tp.findtext("passport_id", "").strip(),
            "preferred_name": tp.findtext("preferred_name", "").strip(),
            "ncbi_taxid":     tp.findtext("ncbi_taxid", "").strip(),
            "taxon_rank":     tp.findtext("taxon_rank", "").strip(),
            "synonyms":       synonyms,
        })

    print(f"Found {len(taxa)} taxa. Starting BacDive fetch...\n")

    # Load existing cache for incremental update
    cache: dict = {}
    if OUT_PATH.exists():
        with open(OUT_PATH) as f:
            cache = json.load(f)
        print(f"Loaded existing cache ({len(cache)} entries). Use --force to re-fetch.\n")

    for i, taxon in enumerate(taxa, 1):
        name     = taxon["preferred_name"]
        rank     = taxon["taxon_rank"]
        taxid    = taxon["ncbi_taxid"]
        synonyms = taxon["synonyms"]

        print(f"[{i:02d}/{len(taxa)}] {name} (taxid={taxid}, rank={rank})")

        # Skip if already cached (unless --force)
        if not force and taxid in cache:
            print("  SKIP — already in cache")
            continue

        if rank == "family":
            print("  SKIP — no BacDive endpoint for family rank")
            cache[taxid] = {"notes": ["family_rank_skipped"], "strains": []}
            continue

        # ── 3-pass query ────────────────────────────────────────────────────
        strain_ids: list[int] = []
        query_used = ""

        # Pass 1: NCBI TaxID
        if taxid:
            print(f"  Pass 1: /search?s[ncbi_tax_id]={taxid}")
            strain_ids = get_ids_by_taxid(taxid)
            if strain_ids:
                query_used = f"ncbi_taxid={taxid}"

        # Pass 2: preferred name
        if not strain_ids:
            genus, species = parse_name(name)
            path_str = f"/taxon/{genus}/{species}" if species else f"/taxon/{genus}"
            print(f"  Pass 2: {path_str}")
            strain_ids = get_ids_by_name(genus, species)
            if strain_ids:
                query_used = f"preferred_name={name}"

        # Pass 3: synonyms
        if not strain_ids:
            for syn in synonyms:
                genus, species = parse_name(syn)
                path_str = f"/taxon/{genus}/{species}" if species else f"/taxon/{genus}"
                print(f"  Pass 3 (synonym '{syn}'): {path_str}")
                strain_ids = get_ids_by_name(genus, species)
                if strain_ids:
                    query_used = f"synonym={syn}"
                    break

        if not strain_ids:
            print("  No BacDive match across all passes")
            cache[taxid] = {
                "preferred_name": name, "ncbi_taxid": taxid, "taxon_rank": rank,
                "query_used": None, "notes": ["no_bacdive_match"], "strains": [],
            }
            continue

        print(f"  Hit via {query_used} — {len(strain_ids)} strain IDs; fetching up to {FETCH_LIMIT}")

        # Fetch up to FETCH_LIMIT records; sort type strains first
        ids_to_fetch = strain_ids[:FETCH_LIMIT]
        strains = []
        for j, sid in enumerate(ids_to_fetch, 1):
            print(f"    [{j}/{len(ids_to_fetch)}] strain {sid} ...", end=" ", flush=True)
            record = fetch_strain(sid)
            if record:
                strains.append({
                    "bacdive_id":    sid,
                    "is_type_strain": is_type_strain(record),
                    "data":          record,
                })
                print("OK")
            else:
                print("FAILED")

        # Type strains first so aggregation in db_fetch_agent can prefer them
        strains.sort(key=lambda s: (0 if s["is_type_strain"] else 1))

        cache[taxid] = {
            "preferred_name":        name,
            "ncbi_taxid":            taxid,
            "taxon_rank":            rank,
            "query_used":            query_used,
            "total_bacdive_strains": len(strain_ids),
            "fetched_strains":       len(strains),
            "type_strain_count":     sum(1 for s in strains if s["is_type_strain"]),
            "bacdive_ids":           strain_ids,
            "strains":               strains,
            "notes":                 [],
        }
        print(f"  Stored {len(strains)} records "
              f"({cache[taxid]['type_strain_count']} type strains first)")

        # Persist after each taxon so partial runs are not lost
        OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        with open(OUT_PATH, "w") as f:
            json.dump(cache, f, indent=2)

    print(f"\nDone. Cache written to {OUT_PATH}")
    print(f"Taxa with strains : {sum(1 for v in cache.values() if v.get('strains'))}")
    print(f"Taxa skipped/empty: {sum(1 for v in cache.values() if not v.get('strains'))}")


if __name__ == "__main__":
    main()
