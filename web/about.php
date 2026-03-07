<?php
require_once 'db_connect.php';

try {
    $n_taxa = $pdo->query("SELECT COUNT(*) FROM mca_taxon_passport")->fetchColumn();
    $n_clinical = $pdo->query("SELECT COUNT(DISTINCT passport_id) FROM mca_clinical_association")->fetchColumn();
    $n_cites = $pdo->query("SELECT COUNT(DISTINCT pmid) FROM (SELECT pmid FROM mca_taxon_evidence_pmid UNION SELECT pmid FROM mca_clinical_association_pmid) as c")->fetchColumn();
    
    $version_info = $pdo->query("SELECT version, last_reviewed FROM mca_taxon_passport ORDER BY last_reviewed DESC LIMIT 1")->fetch();
    $db_version = $version_info['version'] ?? 'v0.1';
    $latest_date = $version_info['last_reviewed'] ?? '2026-03-03';
    $xml_file = "data/MCA_DB_" . htmlspecialchars($db_version) . ".xml";

} catch (\PDOException $e) {
    error_log($e->getMessage());
    $xml_file = "#";
}

include 'header.php'; 
?>

<div class="page-content">
    <div class="logo-container">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <h2>About MCA</h2>
    <p>
        <strong>Microbial Clinical Atlas (MCA)</strong> is a curated catalogue of <strong>Taxon Passports</strong> that summarizes clinically relevant microbial features in a standardized, microbiome-ready format. <strong>MCA</strong> is designed to support both microbiologists and newcomers to microbiome analysis by <strong>providing reproducible, versioned annotations that remain stable across time, projects, and analytical pipelines</strong>.
    </p>

    <div class="callout">
        <div class="muted">
            What <b>MCA</b> offers is a set of structured, comparable <b>Taxon Passports</b> that enforce the same terminology and field definitions across organisms, so interpretation is not dependent on <i>ad hoc</i> phrasing or analyst experience. By pairing controlled vocabularies with versioned records, <b>MCA</b> supports transparent comparison between taxa and consistent reporting across studies, while remaining approachable for users building their first microbiome workflows.
        </div>
    </div>

    <div class="hr-soft"></div>

    <h2>Features</h2>
    <ul>
        <li>Provide consistent, controlled-vocabulary descriptions of clinically relevant taxa</li>
        <li>Enable reproducible interpretation through explicit passport versioning and review dates</li>
        <li>Reduce ambiguity from changing nomenclature by mapping taxa to stable identifiers and documented synonyms</li>
    </ul>

    <div class="hr-soft"></div>

    <div class="grid-2">
        <div class="card">
            <h3>Coverage</h3>
            <p style="margin:0 0 10px 0;">MCA at a glance:</p>
            <ul style="margin:0; list-style-type: none; padding-left: 0;">
                <li>Taxon Passport entries: <strong><?php echo htmlspecialchars($n_taxa); ?></strong></li>
                <li>Clinical associations captured: <strong><?php echo htmlspecialchars($n_clinical); ?></strong></li>
                <li>Citations linked: <strong><?php echo htmlspecialchars($n_cites); ?></strong></li>
                <li>Last updated: <strong><?php echo htmlspecialchars($latest_date); ?></strong></li>
            </ul>
            <div class="callout" style="margin-top: auto;">
                <div class="muted">
                    The complete database is available for download in XML format <a href="<?php echo $xml_file; ?>" target="_blank">here</a>.
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Curation Process</h3>
            <p style="margin:0 0 10px 0;">How MCA Taxon Passports are curated:</p>
            <ol style="margin:0;" type="i">
                <li>We collect information from papers, guidelines, and trusted microbial databases</li>
                <li>We standardize it into a fixed set of fields and terms so taxa are easy to compare</li>
                <li>We attach citations and an evidence grade to key claims</li>
                <li>We publish versioned Taxon Passports with review dates, and update them over time.</li>
            </ol>
        </div>
    </div>
</div>

<?php include 'footer.php'; ?>