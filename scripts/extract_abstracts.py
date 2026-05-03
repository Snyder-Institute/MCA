#!/usr/bin/env python3
"""extract_abstracts.py — populate MCA_review.paper_snapshot from MCA.paper + NCBI.

For every PMID in MCA.paper, the script:
  1. Reads paper metadata from MCA.paper (title, authors, journal, year,
     study_design, sample_size) — read-only on MCA.
  2. Fetches the canonical abstract for that PMID from NCBI's PubMed
     efetch API (the XML form preserves structured-abstract labels like
     Background / Methods / Results / Conclusions).
  3. UPSERTs a row into MCA_review.paper_snapshot.

This replaces the earlier PDF-heuristic extractor: PubMed-canonical
abstracts are complete, free of mid-sentence truncation, and consistent
across reviewers' screens.

Usage (run from repo root, after sync_review_data.py):
    python3 scripts/extract_abstracts.py
    python3 scripts/extract_abstracts.py --batch 10   # smaller batches

Be polite to NCBI: default rate is 3 requests/sec without an API key,
so this script makes one batched efetch call covering all PMIDs by
default. Set NCBI_API_KEY to allow up to 10 requests/sec.
"""

import argparse
import os
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import _db  # noqa: E402

EFETCH_URL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
USER_AGENT = "MCA-Review/1.0 (heewon.seo@ucalgary.ca)"
MAX_RETRIES = 3


def _fetch_pubmed_xml(pmids: list[int]) -> bytes:
    if not pmids:
        return b""
    params = {
        "db": "pubmed",
        "id": ",".join(str(p) for p in pmids),
        "retmode": "xml",
    }
    if os.environ.get("NCBI_API_KEY"):
        params["api_key"] = os.environ["NCBI_API_KEY"]
    url = f"{EFETCH_URL}?{urllib.parse.urlencode(params)}"
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})

    last_err = None
    for attempt in range(MAX_RETRIES):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                return resp.read()
        except (urllib.error.URLError, TimeoutError) as e:
            last_err = e
            time.sleep(1 + attempt)
    raise RuntimeError(f"NCBI efetch failed after {MAX_RETRIES} attempts: {last_err}")


def _parse_articles(xml_bytes: bytes) -> dict[int, dict]:
    """Return {pmid: {abstract: str|None, keywords: str|None}} from PubMed XML."""
    if not xml_bytes:
        return {}
    root = ET.fromstring(xml_bytes)
    out: dict[int, dict] = {}
    for article in root.findall(".//PubmedArticle"):
        pmid_el = article.find(".//MedlineCitation/PMID")
        if pmid_el is None or not pmid_el.text:
            continue
        pmid = int(pmid_el.text)
        # Abstract — preserve structured-abstract section labels.
        parts = []
        for at in article.findall(".//Abstract/AbstractText"):
            label = (at.get("Label") or "").strip()
            text = "".join(at.itertext()).strip()
            if not text:
                continue
            parts.append(f"{label}: {text}" if label else text)
        abstract = "\n\n".join(parts) if parts else None

        # Keywords — prefer MeSH MajorTopic descriptors, then any MeSH, then
        # author KeywordList. Cap at 6 to keep the review.php paper column tidy.
        major, regular, author_kw = [], [], []
        for mh in article.findall(".//MeshHeadingList/MeshHeading/DescriptorName"):
            text = (mh.text or "").strip()
            if not text:
                continue
            (major if (mh.get("MajorTopicYN") == "Y") else regular).append(text)
        for kw in article.findall(".//KeywordList/Keyword"):
            text = (kw.text or "").strip()
            if text:
                author_kw.append(text)

        seen: set[str] = set()
        ordered = []
        for k in major + regular + author_kw:
            kl = k.lower()
            if kl in seen:
                continue
            seen.add(kl)
            ordered.append(k)
            if len(ordered) >= 6:
                break

        out[pmid] = {
            "abstract": abstract,
            "keywords": ", ".join(ordered) if ordered else None,
        }
    return out


def _batch(seq: list, n: int):
    for i in range(0, len(seq), n):
        yield seq[i : i + n]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--batch", type=int, default=50,
                    help="how many PMIDs per efetch request (default 50)")
    args = ap.parse_args()

    with _db.mca() as mca_conn, _db.mca_review() as rev_conn:
        with mca_conn.cursor() as c:
            c.execute(
                "SELECT pmid, title, authors, journal, year, study_design, "
                "       sample_size FROM paper ORDER BY pmid"
            )
            papers = c.fetchall()

        all_pmids = [p["pmid"] for p in papers]
        articles: dict[int, dict] = {}
        for chunk in _batch(all_pmids, args.batch):
            print(f"  fetching {len(chunk)} PMIDs from NCBI ...")
            xml = _fetch_pubmed_xml(chunk)
            articles.update(_parse_articles(xml))
            time.sleep(0.4)  # be polite — well under 3 req/sec

        n_with = n_without = 0
        with rev_conn.cursor() as cw:
            for p in papers:
                pmid = p["pmid"]
                meta = articles.get(pmid) or {}
                abstract = meta.get("abstract")
                keywords = meta.get("keywords")
                if abstract:
                    n_with += 1
                else:
                    n_without += 1
                    print(f"  ! no abstract returned for PMID {pmid}")
                cw.execute(
                    """
                    INSERT INTO paper_snapshot
                        (pmid, title, authors, journal, year, study_design,
                         sample_size, abstract, keywords)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON DUPLICATE KEY UPDATE
                        title=VALUES(title), authors=VALUES(authors),
                        journal=VALUES(journal), year=VALUES(year),
                        study_design=VALUES(study_design),
                        sample_size=VALUES(sample_size),
                        abstract=VALUES(abstract),
                        keywords=VALUES(keywords)
                    """,
                    (pmid, p["title"], p["authors"], p["journal"], p["year"],
                     p["study_design"], p["sample_size"], abstract, keywords),
                )
        rev_conn.commit()

    print()
    print(f"PubMed abstracts fetched : {n_with:3d}")
    print(f"PMIDs missing abstract   : {n_without:3d}")
    print(f"Total snapshotted        : {len(papers):3d}")


if __name__ == "__main__":
    main()
