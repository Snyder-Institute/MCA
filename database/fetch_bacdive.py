"""
fetch_bacdive.py — Build a local BacDive cache for MCA taxa.

Reads the current MCA XML, looks up each taxon on BacDive, fetches all strain
records, and writes a JSON cache keyed by ncbi_taxid.

Output: Dropbox mca/bacdive/bacdive_cache.json

Usage:
    python3 database/fetch_bacdive.py

BacDive API base: https://api.bacdive.dsmz.de  (no /v2/ prefix)
  - /taxon/{genus}/          → list of BacDive strain IDs for a genus
  - /taxon/{genus}/{species} → list of BacDive strain IDs for a species
  - /fetch/{id}              → full strain record JSON
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
XML_PATH   = Path("database/MCA_DB_v1_7_20260402.xml")
OUT_PATH   = Path("/Users/heewon.seo/Library/CloudStorage/Dropbox-BioinformaticsHub/Projects/mca/bacdive/bacdive_cache.json")
BASE_URL   = "https://api.bacdive.dsmz.de"
PAUSE      = 0.4   # seconds between API calls (BacDive is rate-limited)
MAX_STRAINS = 50   # max strain records to fetch per taxon (type strains first)

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


def parse_name(preferred_name: str, rank: str) -> tuple[str, str | None]:
    """Return (genus, species_epithet | None) from preferred_name + rank."""
    parts = preferred_name.split()
    if rank in ("genus", "family"):
        return parts[0], None
    if len(parts) >= 2:
        return parts[0], parts[1]
    return parts[0], None


def get_strain_ids(genus: str, species: str | None) -> list[int]:
    if species:
        data = api_get(f"/taxon/{genus}/{species}")
    else:
        data = api_get(f"/taxon/{genus}")
    time.sleep(PAUSE)
    if not data:
        return []
    results = data.get("results", [])
    if isinstance(results, list):
        return [r for r in results if isinstance(r, int)]
    return []


def fetch_strain(strain_id: int) -> dict | None:
    data = api_get(f"/fetch/{strain_id}")
    time.sleep(PAUSE)
    if not data:
        return None
    results = data.get("results", {})
    if str(strain_id) in results:
        return results[str(strain_id)]
    # Some responses key by integer
    if strain_id in results:
        return results[strain_id]
    # Fallback: first value
    if results:
        return next(iter(results.values()))
    return None


# ── Main ─────────────────────────────────────────────────────────────────────
def main():
    if not XML_PATH.exists():
        # Try from repo root
        alt = Path(__file__).parent.parent / XML_PATH
        if alt.exists():
            xml_path = alt
        else:
            print(f"ERROR: XML not found at {XML_PATH}")
            sys.exit(1)
    else:
        xml_path = XML_PATH

    print(f"Reading {xml_path} ...")
    tree = ET.parse(xml_path)
    root = tree.getroot()

    taxa = []
    for tp in root.findall("TaxonPassport"):
        taxa.append({
            "passport_id":  tp.findtext("passport_id", "").strip(),
            "preferred_name": tp.findtext("preferred_name", "").strip(),
            "ncbi_taxid":   tp.findtext("ncbi_taxid", "").strip(),
            "taxon_rank":   tp.findtext("taxon_rank", "").strip(),
        })

    print(f"Found {len(taxa)} taxa. Starting BacDive fetch...\n")

    cache = {}  # ncbi_taxid → {bacdive_ids: [...], strains: [...], notes: [...]}

    for i, taxon in enumerate(taxa, 1):
        name  = taxon["preferred_name"]
        rank  = taxon["taxon_rank"]
        taxid = taxon["ncbi_taxid"]

        print(f"[{i:02d}/{len(taxa)}] {name} (taxid={taxid}, rank={rank})")

        if rank == "family":
            print("  SKIP — no BacDive endpoint for family rank")
            cache[taxid] = {"notes": ["family_rank_skipped"], "strains": []}
            continue

        genus, species = parse_name(name, rank)
        print(f"  Querying /taxon/{genus}/{species or ''} ...")

        strain_ids = get_strain_ids(genus, species)
        if not strain_ids:
            print(f"  No strain IDs found")
            cache[taxid] = {"notes": ["no_bacdive_match"], "strains": []}
            continue

        print(f"  Found {len(strain_ids)} strain IDs — fetching up to {MAX_STRAINS}")
        ids_to_fetch = strain_ids[:MAX_STRAINS]

        strains = []
        for j, sid in enumerate(ids_to_fetch, 1):
            print(f"    [{j}/{len(ids_to_fetch)}] fetching strain {sid} ...", end=" ", flush=True)
            record = fetch_strain(sid)
            if record:
                strains.append({"bacdive_id": sid, "data": record})
                print("OK")
            else:
                print("FAILED")

        cache[taxid] = {
            "preferred_name": name,
            "ncbi_taxid": taxid,
            "taxon_rank": rank,
            "total_bacdive_strains": len(strain_ids),
            "fetched_strains": len(strains),
            "bacdive_ids": strain_ids,
            "strains": strains,
            "notes": [],
        }
        print(f"  Stored {len(strains)} strain records")

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_PATH, "w") as f:
        json.dump(cache, f, indent=2)

    print(f"\nDone. Cache written to {OUT_PATH}")
    print(f"Taxa with strains: {sum(1 for v in cache.values() if v.get('strains'))}")
    print(f"Taxa skipped/empty: {sum(1 for v in cache.values() if not v.get('strains'))}")


if __name__ == "__main__":
    main()
