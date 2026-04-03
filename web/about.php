<?php
require_once 'db_connect.php';

// ── Live stats (all queried fresh on each page load — no caching needed) ──
try {
    $n_passports   = $pdo->query("SELECT COUNT(*) FROM passport")->fetchColumn();
    $n_assocs      = $pdo->query("SELECT COUNT(*) FROM association")->fetchColumn();
    $n_papers      = $pdo->query("SELECT COUNT(*) FROM paper")->fetchColumn();
    $n_refs        = $pdo->query("SELECT COUNT(*) FROM assoc_ref")->fetchColumn();
    $n_pmids       = $pdo->query("
        SELECT COUNT(DISTINCT pmid) FROM (
            SELECT pmid FROM passport_pmid
            UNION
            SELECT pmid FROM assoc_pmid
        ) AS all_pmids
    ")->fetchColumn();
    $latest_date   = $pdo->query("SELECT last_reviewed FROM passport ORDER BY last_reviewed DESC LIMIT 1")->fetchColumn();
    $db_version    = $pdo->query("SELECT key_value FROM meta WHERE key_name = 'db_version'")->fetchColumn();

    // Evidence distribution
    $ev_rows = $pdo->query("
        SELECT evidence_level, COUNT(*) AS n
        FROM association
        GROUP BY evidence_level
        ORDER BY FIELD(evidence_level, 'E3', 'E2', 'E1', 'UNCERTAIN')
    ")->fetchAll(\PDO::FETCH_KEY_PAIR);
    $ev_e3 = $ev_rows['E3'] ?? 0;
    $ev_e2 = $ev_rows['E2'] ?? 0;
    $ev_e1 = $ev_rows['E1'] ?? 0;
} catch (\PDOException $e) {
    error_log($e->getMessage());
    $n_passports = $n_assocs = $n_papers = $n_refs = $n_pmids = 0;
    $latest_date = $db_version = 'n/a';
    $ev_e3 = $ev_e2 = $ev_e1 = 0;
}

include 'header.php';
?>

<style>
/* ── Page layout ─────────────────────────────────────────────────── */
.about-wrap { max-width: 900px; margin: 0 auto; padding: 30px 16px 60px; }

/* ── Stat strip ──────────────────────────────────────────────────── */
.stat-strip {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
    gap: 12px;
    margin: 28px 0 36px;
}
.stat-card {
    background: #fff;
    border: 1px solid #e6e6e6;
    border-radius: 10px;
    padding: 16px 14px 14px;
    text-align: center;
    box-shadow: 0 2px 4px rgba(0,0,0,0.04);
}
.stat-number {
    font-family: "Montserrat", sans-serif;
    font-size: 28px;
    font-weight: 800;
    color: #404f7c;
    line-height: 1.1;
}
.stat-label {
    font-size: 11px;
    color: #888;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-top: 4px;
}

/* ── Section titles ──────────────────────────────────────────────── */
.about-section { margin: 40px 0; }
.about-section h2 { font-size: 20px; margin: 0 0 14px; border-bottom: 1px solid #efefef; padding-bottom: 8px; }

/* ── Pipeline steps ──────────────────────────────────────────────── */
.pipeline { display: flex; flex-direction: column; gap: 0; }
.pipeline-step {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    position: relative;
    padding-bottom: 24px;
}
.pipeline-step:last-child { padding-bottom: 0; }
.pipeline-step:not(:last-child)::before {
    content: '';
    position: absolute;
    left: 18px;
    top: 40px;
    bottom: 0;
    width: 2px;
    background: #e6e6e6;
}
.step-badge {
    flex-shrink: 0;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #404f7c;
    color: #fff;
    font-family: "Montserrat", sans-serif;
    font-weight: 800;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    z-index: 1;
}
.step-body { flex: 1; padding-top: 4px; }
.step-body strong { font-size: 15px; color: #222; }
.step-body p { margin: 4px 0 0; font-size: 13px; color: #555; line-height: 1.5; }
.step-body .tag-row { margin-top: 6px; display: flex; flex-wrap: wrap; gap: 5px; }
.step-tag {
    font-size: 11px;
    background: #f0f3fb;
    color: #404f7c;
    border: 1px solid #cdd4f0;
    border-radius: 4px;
    padding: 2px 8px;
    font-family: monospace;
}

/* ── Pathobiont key ──────────────────────────────────────────────── */
.pb-key-row { display: flex; flex-wrap: wrap; gap: 16px; margin-top: 4px; }
.pb-key-item { display: flex; align-items: center; gap: 8px; }
.pb-key-badge { padding: 4px 12px; border-radius: 4px; font-weight: 800; font-size: 11px; text-transform: uppercase; letter-spacing: 0.04em; border: 1px solid; }
.pb-key-yes { background: #007bff; color: #fff; border-color: #0056b3; }
.pb-key-ctx { background: #4b5563; color: #fff; border-color: #374151; }
.pb-key-no  { background: #f3f4f6; color: #6b7280; border-color: #d1d5db; }
.pb-key-desc { font-size: 13px; color: #555; }

/* ── Evidence grade badges ───────────────────────────────────────── */
.ev-grade-badge {
    padding: 3px 8px;
    border-radius: 4px;
    font-family: "Montserrat", sans-serif;
    font-weight: 800;
    font-size: 11px;
    text-align: center;
    border: 1px solid;
    white-space: nowrap;
    flex-shrink: 0;
}
.ev-badge-e3 { background: #dcfce7; color: #166534; border-color: #4ade80; }
.ev-badge-e2 { background: #fef3c7; color: #92400e; border-color: #fbbf24; }
.ev-badge-e1 { background: #f3f4f6; color: #6b7280; border-color: #d1d5db; }
.ev-bar-desc { font-size: 13px; color: #555; }

/* ── Download card ───────────────────────────────────────────────── */
.download-card {
    background: #f7f9ff;
    border: 1px solid #cdd4f0;
    border-left: 4px solid #404f7c;
    border-radius: 8px;
    padding: 18px 20px;
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}
.download-card-text { flex: 1; min-width: 200px; }
.download-card-text strong { font-size: 15px; color: #222; }
.download-card-text p { margin: 4px 0 0; font-size: 13px; color: #555; }
.btn-download {
    display: inline-block;
    background: #404f7c;
    color: #fff !important;
    font-family: "Montserrat", sans-serif;
    font-weight: 700;
    font-size: 13px;
    padding: 9px 20px;
    border-radius: 6px;
    text-decoration: none !important;
    white-space: nowrap;
}
.btn-download:hover { background: #2e3a5e; color: #fff !important; text-decoration: none !important; }

/* ── Data model table ────────────────────────────────────────────── */
.dm-table { width: 100%; border-collapse: collapse; font-size: 13px; margin-top: 8px; }
.dm-table th { text-align: left; padding: 6px 10px; background: #f7f7f7; border: 1px solid #e6e6e6; color: #333; font-weight: 700; }
.dm-table td { padding: 6px 10px; border: 1px solid #e6e6e6; color: #444; vertical-align: top; }
.dm-table tr:nth-child(even) td { background: #fafafa; }
</style>

<div class="about-wrap">

    <div class="logo-container" style="margin-bottom: 20px;">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <h1 style="font-size: 28px; margin: 0 0 10px;">About MCA</h1>
    <p style="color: #555; font-size: 15px; line-height: 1.65; margin: 0 0 6px; text-align: justify;">
        The <strong>Microbial Clinical Atlas (MCA)</strong> is a curated knowledge base of <strong>Taxon Passports</strong> — structured records that summarise the clinically relevant biology, ecology, and evidence-linked associations of human-associated microorganisms. MCA is designed to make microbiome findings reproducible and comparable across studies by enforcing controlled vocabularies, stable identifiers, and explicit evidence grading.
    </p>

    <!-- ── Live stats ─────────────────────────────────────────────── -->
    <div class="stat-strip">
        <div class="stat-card">
            <div class="stat-number"><?php echo (int)$n_passports; ?></div>
            <div class="stat-label">Taxon Passports</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><?php echo (int)$n_assocs; ?></div>
            <div class="stat-label">Clinical Associations</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><?php echo (int)$n_papers; ?></div>
            <div class="stat-label">Papers Curated</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><?php echo (int)$n_refs; ?></div>
            <div class="stat-label">Ontology References</div>
        </div>
    </div>

    <!-- ── Pathobiont key ────────────────────────────────────────── -->
    <div class="about-section">
        <h2>Pathobiont Status</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 14px;">
            Each Taxon Passport records whether the organism is considered a pathobiont — a commensal microorganism capable of causing disease under specific conditions such as immunosuppression, antibiotic disruption, or barrier dysfunction.
        </p>
        <div style="display: flex; flex-direction: column; gap: 10px;">
            <div class="pb-key-item">
                <span class="pb-key-badge pb-key-yes">Yes</span>
                <span class="pb-key-desc">Recognised pathobiont</span>
            </div>
            <div class="pb-key-item">
                <span class="pb-key-badge pb-key-ctx">Context dependent</span>
                <span class="pb-key-desc">Pathobiont status depends on host factors or clinical setting</span>
            </div>
            <div class="pb-key-item">
                <span class="pb-key-badge pb-key-no">Unknown / No</span>
                <span class="pb-key-desc">Insufficient evidence or not considered a pathobiont</span>
            </div>
        </div>
    </div>

    <!-- ── Evidence distribution ──────────────────────────────────── -->
    <div class="about-section">
        <h2>Evidence Distribution</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 12px;">
            Clinical associations are graded by study design. Each grade reflects the strongest design reported for that finding.
        </p>
        <?php
        $grades = [
            ['E3', 'ev-badge-e3', 'Strong — systematic review, meta-analysis, or multiple independent human cohorts'],
            ['E2', 'ev-badge-e2', 'Moderate — single human cohort, RCT, case-control, or cross-sectional'],
            ['E1', 'ev-badge-e1', 'Limited — animal model, in vitro, case report, or mechanistic work only'],
        ];
        ?>
        <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 4px;">
            <?php foreach ($grades as [$label, $cls, $desc]): ?>
            <div style="display: flex; align-items: center; gap: 12px;">
                <span class="ev-grade-badge <?php echo $cls; ?>"><?php echo $label; ?></span>
                <span class="ev-bar-desc"><?php echo $desc; ?></span>
            </div>
            <?php endforeach; ?>
        </div>
    </div>

    <!-- ── Curation pipeline ──────────────────────────────────────── -->
    <div class="about-section">
        <h2>Curation Process</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 20px;">
            Each Taxon Passport is assembled by a two-skill AI-assisted curation pipeline. A human curator reviews every staging file before any changes are committed to the database.
        </p>

        <div class="pipeline">

            <div class="pipeline-step">
                <div class="step-badge">1</div>
                <div class="step-body">
                    <strong>Paper Analysis</strong>
                    <p>A PDF (filename = PMID) is submitted to the <em>Paper Curator</em> skill. An analyst agent reads the full paper, extracts metadata (title, authors, journal, year, study design, population, sample size), and identifies all microbial taxa mentioned.</p>
                </div>
            </div>

            <div class="pipeline-step">
                <div class="step-badge">2</div>
                <div class="step-body">
                    <strong>Database Fetch &amp; Entity Extraction</strong>
                    <p>Per taxon, two agents run in parallel: a <em>DB Fetch</em> agent queries NCBI Taxonomy and BacDive (by TaxID) for biology and ecology fields; an <em>Entity Extractor</em> agent reads the paper for the clinical layer — pathobiont status, bloom triggers, AMR highlights, metabolites, and individual clinical associations with evidence type.</p>
                    <div class="tag-row">
                        <span class="step-tag">NCBI Taxonomy</span>
                        <span class="step-tag">BacDive</span>
                        <span class="step-tag">clinical_roles</span>
                        <span class="step-tag">bloom_triggers</span>
                        <span class="step-tag">amr_highlights</span>
                        <span class="step-tag">metabolites</span>
                    </div>
                </div>
            </div>

            <div class="pipeline-step">
                <div class="step-badge">3</div>
                <div class="step-body">
                    <strong>Routing, Grading &amp; Ontology Enrichment</strong>
                    <p>A <em>Routing</em> agent checks whether the taxon already exists in the XML database (CREATE vs UPDATE). A <em>Grading</em> agent assigns an evidence grade (E1 / E2 / E3) for the paper based purely on study design. Three enrichment agents run in parallel: <em>MeSH</em> (NLM E-utilities), <em>KEGG</em> (local flat-file mirror), and <em>ARO</em> (CARD ontology).</p>
                    <div class="tag-row">
                        <span class="step-tag">E1 / E2 / E3</span>
                        <span class="step-tag">MeSH IDs</span>
                        <span class="step-tag">KEGG Disease</span>
                        <span class="step-tag">KEGG Drug</span>
                        <span class="step-tag">KEGG Compound</span>
                        <span class="step-tag">ARO (AMR)</span>
                    </div>
                </div>
            </div>

            <div class="pipeline-step">
                <div class="step-badge">4</div>
                <div class="step-body">
                    <strong>Staging File &amp; Human Review</strong>
                    <p>A structured JSON staging file is written per taxon (<code>staging/YYYY-MM-DD_taxon-name.json</code>). A human curator reviews every field — proposed additions, evidence rationale, and ontology IDs — before approving.</p>
                </div>
            </div>

            <div class="pipeline-step">
                <div class="step-badge">5</div>
                <div class="step-body">
                    <strong>XML Update &amp; SQL Export</strong>
                    <p>Approved staging files are applied to the versioned XML database by the <em>XML Update</em> skill. A content hash is computed per association for deduplication. Applied files are archived; a full SQL dump is generated automatically from the updated XML.</p>
                    <div class="tag-row">
                        <span class="step-tag">CREATE / UPDATE</span>
                        <span class="step-tag">content_hash</span>
                        <span class="step-tag">versioned XML</span>
                        <span class="step-tag">SQL dump</span>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ── Data model ─────────────────────────────────────────────── -->
    <div class="about-section">
        <h2>Data Model</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 12px;">
            Each Taxon Passport is the central record, linked to satellite tables via a surrogate integer primary key. The canonical export format is versioned XML; the MySQL schema is derived from it via <code>xml2sql.py</code>.
        </p>
        <table class="dm-table">
            <thead>
                <tr><th>Layer</th><th>Fields</th><th>Source</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Identity</strong></td>
                    <td>passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, synonyms</td>
                    <td>NCBI Taxonomy</td>
                </tr>
                <tr>
                    <td><strong>Biology</strong></td>
                    <td>gram_status, oxygen_tolerance, morphology, key_traits, bacdive_url</td>
                    <td>BacDive</td>
                </tr>
                <tr>
                    <td><strong>Ecology</strong></td>
                    <td>primary_niches (+ MeSH anatomy ID), reservoirs, transmission_routes</td>
                    <td>BacDive / literature</td>
                </tr>
                <tr>
                    <td><strong>Clinical Profile</strong></td>
                    <td>is_pathobiont, clinical_roles, typical_specimens, bloom_triggers, risk_contexts, amr_highlights (+ ARO ID)</td>
                    <td>Curated literature</td>
                </tr>
                <tr>
                    <td><strong>Metabolites</strong></td>
                    <td>metabolite_name, relationship (produces / consumes / modifies), KEGG Compound ID, ChEBI ID</td>
                    <td>Curated literature; KEGG LIGAND</td>
                </tr>
                <tr>
                    <td><strong>Clinical Associations</strong></td>
                    <td>association_text, evidence_level (E1–E3), evidence_type, content_hash, assoc_refs (MeSH + KEGG Disease ID), PMIDs</td>
                    <td>Curated literature; NLM MeSH; KEGG MEDICUS</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ── Acknowledgements ──────────────────────────────────────── -->
    <div class="about-section">
        <h2>Acknowledgements</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 14px;">
            MCA integrates data from the following publicly available resources. We gratefully acknowledge the teams that build and maintain them.
        </p>
        <table class="dm-table">
            <thead>
                <tr><th>Resource</th><th>Used For</th><th>Reference</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>NCBI Taxonomy</strong></td>
                    <td>Taxon lineage, rank, preferred name, synonyms, TaxID</td>
                    <td>National Center for Biotechnology Information, U.S. National Library of Medicine</td>
                </tr>
                <tr>
                    <td><strong>NLM MeSH</strong></td>
                    <td>MeSH term annotations on clinical associations; anatomy IDs on body-site fields</td>
                    <td>Medical Subject Headings, U.S. National Library of Medicine</td>
                </tr>
                <tr>
                    <td><strong>BacDive</strong></td>
                    <td>Gram status, oxygen tolerance, morphology, key traits, primary niches</td>
                    <td>BacDive — the Bacterial Diversity Metadatabase, DSMZ (Leibniz Institute)</td>
                </tr>
                <tr>
                    <td><strong>KEGG</strong></td>
                    <td>KEGG Disease IDs on clinical associations; KEGG Drug IDs on bloom triggers; KEGG Compound IDs on metabolites</td>
                    <td>Kyoto Encyclopedia of Genes and Genomes, Kanehisa Laboratories</td>
                </tr>
                <tr>
                    <td><strong>CARD / ARO</strong></td>
                    <td>Antibiotic Resistance Ontology identifiers on AMR highlights</td>
                    <td>Comprehensive Antibiotic Resistance Database, McMaster University</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ── Local data mirrors ───────────────────────────────────── -->
    <div class="about-section">
        <h2>Curation Data Mirrors</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 12px;">
            For curation speed and reproducibility, the pipeline maintains local snapshots of all reference databases used during enrichment. These mirrors are updated periodically and are not served publicly.
        </p>
        <table class="dm-table">
            <thead>
                <tr><th>Database</th><th>Snapshot date</th><th>Used by</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>NCBI Taxonomy</strong></td>
                    <td>2026-04-02</td>
                    <td>TaxID lookup, name resolution</td>
                </tr>
                <tr>
                    <td><strong>BacDive</strong></td>
                    <td>2026-04-02</td>
                    <td>Gram status, oxygen tolerance, morphology, isolation sources</td>
                </tr>
                <tr>
                    <td><strong>KEGG</strong></td>
                    <td>2025-10-26</td>
                    <td>Disease, drug, and compound ID enrichment</td>
                </tr>
                <tr>
                    <td><strong>CARD / ARO</strong></td>
                    <td>2026-04-02</td>
                    <td>AMR resistance ontology IDs</td>
                </tr>
                <tr>
                    <td><strong>ChEBI</strong></td>
                    <td>2026-04-02</td>
                    <td>Metabolite ID enrichment</td>
                </tr>
                <tr>
                    <td><strong>VFDB</strong></td>
                    <td>2026-03-27</td>
                    <td>Virulence factor annotations</td>
                </tr>
                <tr>
                    <td><strong>DOID</strong></td>
                    <td>2026-04-02</td>
                    <td>Disease ontology cross-referencing</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ── Download ───────────────────────────────────────────────── -->
    <div class="about-section">
        <h2>Download &amp; Source</h2>
        <p style="font-size: 14px; color: #555; margin: 0 0 14px;">
            The complete database is published as a versioned XML file and updated with each curation cycle.
        </p>
        <div class="download-card" style="margin-bottom: 12px;">
            <div class="download-card-text">
                <strong>MCA_DB_latest.xml</strong>
                <p>Full database in structured XML — includes all passports, associations, ontology references, and metadata. Suitable for downstream tools and programmatic import.</p>
            </div>
            <a class="btn-download" href="data/MCA_DB_latest.xml" download>Download XML</a>
        </div>
        <div class="download-card">
            <div class="download-card-text">
                <strong>GitHub</strong>
                <p>Source code, schema definitions, curation scripts, and issue tracking for the MCA project.</p>
            </div>
            <a class="btn-download" href="https://github.com/Snyder-Institute/MCA" target="_blank" rel="noopener">View on GitHub</a>
        </div>
    </div>

</div>

<?php include 'footer.php'; ?>
