<?php
require_once 'db_connect.php';

$id = isset($_GET['id']) ? trim($_GET['id']) : '';
if (empty($id)) {
    header("Location: index.php");
    exit;
}

try {
    $stmt = $pdo->prepare("
        SELECT p.id, p.passport_id, p.preferred_name, p.lineage, p.ncbi_taxid,
               p.taxon_rank, p.domain, p.is_pathobiont, p.last_reviewed,
               b.gram_status, b.morphology, b.oxygen_tolerance, b.bacdive_url
        FROM passport p
        LEFT JOIN biology b ON b.passport_id = p.id
        WHERE p.passport_id = ?
    ");
    $stmt->execute([$id]);
    $taxon = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($taxon) {
        $p_id = $taxon['id'];
        $raw_version = $pdo->query("SELECT key_value FROM meta WHERE key_name = 'db_version'")->fetchColumn() ?: '';
        $db_version = $raw_version ? preg_replace('/^(v\d+)_(\d+)_\d+$/', '$1.$2', $raw_version) : 'n/a';

        function getTags($pdo, $p_id, $category) {
            $s = $pdo->prepare("SELECT DISTINCT value FROM taxon_tag WHERE passport_id = ? AND category = ? ORDER BY value ASC");
            $s->execute([$p_id, $category]);
            return $s->fetchAll(PDO::FETCH_COLUMN);
        }

        function getTagsWithExtId($pdo, $p_id, $category) {
            $s = $pdo->prepare("SELECT DISTINCT value, ext_id FROM taxon_tag WHERE passport_id = ? AND category = ? ORDER BY value ASC");
            $s->execute([$p_id, $category]);
            return $s->fetchAll(PDO::FETCH_ASSOC);
        }

        $synonyms    = getTags($pdo, $p_id, 'synonym');
        $traits      = getTags($pdo, $p_id, 'key_trait');
        $niches      = getTags($pdo, $p_id, 'primary_niche');
        $reservoirs  = getTags($pdo, $p_id, 'reservoir');
        $routes      = getTags($pdo, $p_id, 'transmission_route');
        $roles       = getTags($pdo, $p_id, 'role');
        $specimens   = getTags($pdo, $p_id, 'typical_specimen');
        $triggers    = getTagsWithExtId($pdo, $p_id, 'bloom_trigger');
        $risk_groups = getTags($pdo, $p_id, 'risk_context');
        $amr_alerts  = getTagsWithExtId($pdo, $p_id, 'amr_highlight');
        $vf_entries  = getTagsWithExtId($pdo, $p_id, 'virulence_factor');

        $pmid_stmt = $pdo->prepare("SELECT pmid FROM passport_pmid WHERE passport_id = ? ORDER BY pmid ASC");
        $pmid_stmt->execute([$p_id]);
        $pmids = $pmid_stmt->fetchAll(PDO::FETCH_COLUMN);

        $assoc_stmt = $pdo->prepare("
            SELECT a.id, a.association_text, a.evidence_level,
                   GROUP_CONCAT(ap.pmid ORDER BY ap.pmid SEPARATOR ', ') as clinical_pmids
            FROM association a
            LEFT JOIN assoc_pmid ap ON ap.association_id = a.id
            WHERE a.passport_id = ?
            GROUP BY a.id
            ORDER BY FIELD(a.evidence_level, 'E3', 'E2', 'E1', 'UNCERTAIN') ASC, a.id ASC
        ");
        $assoc_stmt->execute([$p_id]);
        $associations = $assoc_stmt->fetchAll(PDO::FETCH_ASSOC);

        $assoc_ids = array_column($associations, 'id');
        $assoc_refs_map = [];
        if (!empty($assoc_ids)) {
            $placeholders = implode(',', array_fill(0, count($assoc_ids), '?'));
            $ref_stmt = $pdo->prepare("SELECT association_id, ref_type, ref_id, ref_label FROM assoc_ref WHERE association_id IN ($placeholders)");
            $ref_stmt->execute($assoc_ids);
            foreach ($ref_stmt->fetchAll(PDO::FETCH_ASSOC) as $ref) {
                $assoc_refs_map[$ref['association_id']][] = $ref;
            }
        }

        $met_stmt = $pdo->prepare("SELECT metabolite_name, relationship, kegg_compound_id, chebi_id FROM metabolite WHERE passport_id = ?");
        $met_stmt->execute([$p_id]);
        $metabolites = $met_stmt->fetchAll(PDO::FETCH_ASSOC);

        $papers_stmt = $pdo->prepare("
            SELECT DISTINCT pa.pmid, pa.title, pa.authors, pa.journal, pa.year,
                   pa.study_design, pa.population, pa.sample_size
            FROM paper pa
            WHERE pa.pmid IN (
                SELECT ap.pmid FROM assoc_pmid ap
                INNER JOIN association a ON a.id = ap.association_id
                WHERE a.passport_id = ?
                UNION
                SELECT pp.pmid FROM passport_pmid pp WHERE pp.passport_id = ?
            )
            ORDER BY pa.year ASC, pa.pmid ASC
        ");
        $papers_stmt->execute([$p_id, $p_id]);
        $papers = $papers_stmt->fetchAll(PDO::FETCH_ASSOC);

        $niche_vals = implode("','", array_map(fn($v) => addslashes($v), $niches));
        $risk_vals  = implode("','", array_map(fn($v) => addslashes($v), $risk_groups));
        $related_taxa = [];
        if (!empty($niches) || !empty($risk_groups)) {
            $rel_conditions = [];
            $rel_params = [];
            if (!empty($niches)) {
                $np = implode(',', array_fill(0, count($niches), '?'));
                $rel_conditions[] = "(t.category = 'primary_niche' AND t.value IN ($np))";
                foreach ($niches as $n) $rel_params[] = $n;
            }
            if (!empty($risk_groups)) {
                $rp = implode(',', array_fill(0, count($risk_groups), '?'));
                $rel_conditions[] = "(t.category = 'risk_context' AND t.value IN ($rp))";
                foreach ($risk_groups as $r) $rel_params[] = $r;
            }
            $rel_params[] = $p_id;
            $rel_sql = "
                SELECT p2.passport_id, p2.preferred_name, p2.is_pathobiont,
                       MAX(a.evidence_level) as top_evidence,
                       GROUP_CONCAT(DISTINCT t.category ORDER BY t.category SEPARATOR ',') as match_cats
                FROM taxon_tag t
                INNER JOIN passport p2 ON p2.id = t.passport_id
                LEFT JOIN association a ON a.passport_id = p2.id
                WHERE (" . implode(' OR ', $rel_conditions) . ")
                  AND p2.id != ?
                GROUP BY p2.passport_id, p2.preferred_name, p2.is_pathobiont
                ORDER BY p2.passport_id ASC
                LIMIT 6
            ";
            $rel_stmt = $pdo->prepare($rel_sql);
            $rel_stmt->execute($rel_params);
            $related_taxa = $rel_stmt->fetchAll(PDO::FETCH_ASSOC);
        }

        $lineage_parts = array_filter(array_map('trim', explode(';', $taxon['lineage'] ?? '')));
        $lineage_crumbs = array_map(fn($p) => '<span class="lineage-crumb">' . htmlspecialchars($p) . '</span>', array_values($lineage_parts));
        $formatted_lineage = implode('<span class="lineage-sep"> › </span>', $lineage_crumbs) ?: 'n/a';
    }
} catch (PDOException $e) {
    error_log("[passport.php] DB error: " . $e->getMessage());
    http_response_code(500);
    require 'error_page.php';
    exit;
}

// Set 404 status before any output if no passport was found.
if (empty($taxon)) {
    http_response_code(404);
}

// Per-passport metadata for link previews (Slack, Twitter, Open Graph).
if (!empty($taxon)) {
    $page_title       = $taxon['preferred_name'] . ' — ' . $taxon['passport_id'] . ' | Microbial Clinical Atlas';
    $rank_label       = $taxon['taxon_rank'] ? ucfirst($taxon['taxon_rank']) . ' · ' : '';
    $page_description = $rank_label . ($taxon['lineage'] ?? '') .
                        ' — Taxon Passport with ecology, clinical profile, and evidence-graded associations.';
    $page_url         = 'https://mca.thebiohub.ca/' . $taxon['passport_id'];
}

include 'header.php';
?>

<style>
    .passport-header { border-bottom: 2px solid #eee; padding-bottom: 6px; margin-bottom: 6px; }
    .section-title { font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; color: #888; margin-bottom: 15px; font-weight: 800; border-bottom: 1px solid #eee; padding-bottom: 5px; }

    .data-item { margin-bottom: 12px; display: flex; align-items: flex-start; }
    .data-label { font-weight: 700; color: #111; font-size: 13px; width: 140px; flex-shrink: 0; }
    .data-value { color: #444; font-size: 14px; line-height: 1.5; flex-grow: 1; }

    .data-list { margin: 0; padding-left: 18px; list-style-type: disc; color: #555; font-size: 14px; }
    .data-list li { margin-bottom: 4px; line-height: 1.4; }

    .eg-badge { display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border-radius: 4px; font-weight: 900; font-size: 11px; margin-right: 15px; flex-shrink: 0; }
    .eg-E3 { background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd; }
    .eg-E2 { background: #fef3c7; color: #92400e; border: 1px solid #fbbf24; }
    .eg-E1 { background: #f3f4f6; color: #6b7280; border: 1px solid #d1d5db; }

    .pb-container { display: flex; gap: 6px; flex-wrap: wrap; }
    .pb-item { padding: 3px 8px; border-radius: 3px; font-weight: bold; font-size: 9px; text-transform: uppercase; background: #f5f5f5; color: #ccc; border: 1px solid #eee; }
    .pb-active-yes { background: #007bff !important; color: #fff !important; border-color: #0056b3 !important; }
    .pb-active-other { background: #f3f4f6 !important; color: #6b7280 !important; border-color: #d1d5db !important; }
    .pb-active-context { background: #4b5563 !important; color: #fff !important; border-color: #374151 !important; }

    .ev-tooltip { position: relative; display: inline-block; cursor: help; }
    .ev-tooltip .ev-tooltiptext {
        visibility: hidden; width: 280px; background-color: #fff; color: #333; text-align: left;
        border: 1px solid #ccc; border-radius: 4px; padding: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        position: absolute; z-index: 10; bottom: 150%; left: 50%; transform: translateX(-50%);
        opacity: 0; transition: opacity 0.2s;
    }
    .ev-tooltip .ev-tooltiptext .dict-term { font-size: 13px; color: #555; display: block; margin-bottom: 3px; }
    .ev-tooltip .ev-tooltiptext .dict-term-active { font-weight: 900; color: #000; }
    .ev-tooltip:hover .ev-tooltiptext { visibility: visible; opacity: 1; }

    .assoc-ref-tag { display: inline-block; padding: 1px 5px; border-radius: 3px; font-size: 10px; font-weight: 700; font-family: monospace; text-decoration: none; white-space: nowrap; }
    .assoc-ref-row { display: flex; align-items: center; flex-wrap: wrap; gap: 0; }
    .assoc-ref-row .assoc-ref-tag { margin-top: 0; }
    .assoc-ref-mesh { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
    .assoc-ref-mesh:hover { background: #a7f3d0; border-color: #34d399; }
    .assoc-ref-kegg { background: #ffedd5; color: #9a3412; border: 1px solid #fdba74; }
    .assoc-ref-kegg:hover { background: #fed7aa; border-color: #fb923c; }
    .assoc-ref-other { background: #f5f5f5; color: #555; border: 1px solid #ddd; }
    .assoc-ref-other:hover { background: #e8eaf0; color: #404f7c; }

    .lineage-crumb { color: #888; font-size: 13px; }
    .lineage-sep { color: #ccc; font-size: 12px; }

    .metabolite-card { margin-top: 24px; margin-bottom: 24px; }
    .metabolite-rel { display: inline-block; padding: 1px 7px; border-radius: 3px; font-size: 11px; font-weight: 700; text-transform: uppercase; background: #eef0f8; color: #404f7c; border: 1px solid #c8cde8; margin-left: 6px; }

    .paper-block { padding: 12px 0; border-bottom: 1px solid #f0f0f0; }
    .paper-block:last-child { border-bottom: none; }
    .paper-title { font-weight: 700; font-size: 14px; color: #222; }
    .paper-meta { font-size: 12px; color: #777; margin-top: 4px; line-height: 1.6; }

    .timeline-strip { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 8px; }
    .timeline-card { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 8px 12px; border-radius: 5px; background: #f8f9fa; border: 1px solid #e8e8e8; flex: 1 1 205px; max-width: 205px; text-align: center; font-size: 12px; box-sizing: border-box; }
    .timeline-year { font-weight: 900; font-size: 14px; color: #404f7c; }
    .timeline-design { font-size: 10px; color: #888; margin-top: 2px; text-transform: capitalize; }

    .related-taxa-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 10px; }
    .two-col-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }

    @media (max-width: 700px) {
        .two-col-grid { grid-template-columns: 1fr; gap: 20px; }
        .passport-header-inner { flex-direction: column !important; align-items: flex-start !important; gap: 12px; }
        .passport-header-inner > div:last-child { text-align: left !important; }
        .related-taxa-grid { grid-template-columns: repeat(2, 1fr); }
        .data-item { flex-direction: column; }
        .data-label { width: auto !important; margin-bottom: 2px; }
        h1[style*="42px"] { font-size: 28px !important; }
    }
    @media (max-width: 480px) {
        .related-taxa-grid { grid-template-columns: 1fr; }
    }
    .related-taxon-pill { display: flex; flex-direction: column; gap: 4px; padding: 10px 12px; border-radius: 5px; background: #f5f6fa; border: 1px solid #e0e2ee; text-decoration: none; color: #222; transition: background 0.15s; }
    .related-taxon-pill:hover { background: #eaecf7; border-color: #404f7c; }
    .related-taxon-id { font-size: 10px; color: #aaa; font-family: monospace; }
    .rt-name-row { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
    .related-taxon-name { font-size: 13px; font-style: italic; font-weight: 700; color: #222; }
    .rt-match-niche { display: inline-block; padding: 1px 5px; border-radius: 3px; font-size: 10px; font-weight: 700; background: #efefef; color: #555; border: 1px solid #d8d8d8; }
    .rt-match-risk  { display: inline-block; padding: 1px 5px; border-radius: 3px; font-size: 10px; font-weight: 700; background: #f0ece8; color: #7a6a5f; border: 1px solid #ddd0c8; }
</style>

<div class="page-content">
    <?php if ($taxon): ?>
        <div class="passport-header">
            <div class="passport-header-inner" style="display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <h1 style="margin: 0; font-size: 42px; font-style: italic; color: #000; line-height: 1;">
                        <?php echo htmlspecialchars($taxon['preferred_name']); ?>
                    </h1>
                    <div style="margin-top: 12px;">
                        <?php echo $formatted_lineage; ?>
                    </div>

                    <?php if (!empty($synonyms)): ?>
                        <div style="margin-top: 8px; font-size: 13px; color: #888;">
                            <strong style="color: #444;">Synonyms:</strong> <?php echo htmlspecialchars(implode('; ', $synonyms)); ?>
                        </div>
                    <?php endif; ?>
                </div>

                <div style="text-align: right; padding-bottom: 5px;">
                    <span class="badge-id" id="copy-passport-id" style="cursor: copy; font-weight: 900; font-size: 16px; display: block; margin-bottom: 10px; text-align: center; width: 100%; box-sizing: border-box;">
                        <?php echo htmlspecialchars($taxon['passport_id']); ?>
                    </span>

                    <div style="font-size: 12px; color: #888; white-space: nowrap;">
                        TaxID: <a href="https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=<?php echo $taxon['ncbi_taxid']; ?>" target="_blank" style="color:#000; font-weight:bold; text-decoration: none;"><?php echo htmlspecialchars($taxon['ncbi_taxid']); ?></a>
                        <?php if (!empty($taxon['bacdive_url']) && in_array($taxon['taxon_rank'], ['species', 'subspecies', 'strain'])): $bacdive_id = basename(rtrim($taxon['bacdive_url'], '/')); ?>
                        | BacDive: <a href="<?php echo htmlspecialchars($taxon['bacdive_url']); ?>" target="_blank" style="color:#000; font-weight:bold; text-decoration: none;"><?php echo htmlspecialchars($bacdive_id); ?></a>
                        <?php endif; ?>
                        | Rank: <span style="text-transform: capitalize; color: #000; font-weight: bold;"><?php echo htmlspecialchars($taxon['taxon_rank']); ?></span>
                    </div>
                </div>
            </div>
        </div>

        <?php
        $bio_empty = !$taxon['gram_status'] && !$taxon['oxygen_tolerance'] && !$taxon['morphology'] && empty($traits) && empty($taxon['bacdive_url']);
        $eco_empty = empty($niches) && empty($reservoirs) && empty($routes);
        ?>
        <div class="card" style="margin-bottom: 24px;">
            <div class="section-title">Biology &amp; Ecology</div>
            <div class="two-col-grid">
                <div>
                    <div style="font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: #bbb; font-weight: 700; margin-bottom: 10px;">Biology</div>
                    <?php if ($bio_empty): ?>
                        <p class="muted" style="font-size: 13px; margin: 0;">Not characterized at this rank.</p>
                    <?php else: ?>
                        <?php if ($taxon['gram_status']): ?>
                            <div class="data-item"><span class="data-label">Gram Status</span><span class="data-value"><?php echo htmlspecialchars($taxon['gram_status']); ?></span></div>
                        <?php endif; ?>
                        <?php if ($taxon['oxygen_tolerance']): ?>
                            <div class="data-item"><span class="data-label">Oxygen Tolerance</span><span class="data-value"><?php echo htmlspecialchars($taxon['oxygen_tolerance']); ?></span></div>
                        <?php endif; ?>
                        <?php if ($taxon['morphology']): ?>
                            <div class="data-item"><span class="data-label">Morphology</span><span class="data-value"><?php echo htmlspecialchars($taxon['morphology']); ?></span></div>
                        <?php endif; ?>
                        <?php if (!empty($traits)): ?>
                            <div class="data-item">
                                <span class="data-label">Key Traits</span>
                                <ul class="data-list">
                                    <?php foreach($traits as $t): ?><li><?php echo htmlspecialchars($t); ?></li><?php endforeach; ?>
                                </ul>
                            </div>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
                <div>
                    <div style="font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: #bbb; font-weight: 700; margin-bottom: 10px;">Ecology</div>
                    <?php if ($eco_empty): ?>
                        <p class="muted" style="font-size: 13px; margin: 0;">Not characterized at this rank.</p>
                    <?php else: ?>
                        <?php if (!empty($niches)): ?>
                            <div class="data-item"><span class="data-label">Primary Niches</span><span class="data-value"><?php echo htmlspecialchars(implode(', ', $niches)); ?></span></div>
                        <?php endif; ?>
                        <?php if (!empty($reservoirs)): ?>
                            <div class="data-item"><span class="data-label">Reservoir</span><span class="data-value"><?php echo htmlspecialchars(implode(', ', $reservoirs)); ?></span></div>
                        <?php endif; ?>
                        <?php if (!empty($routes)): ?>
                            <div class="data-item">
                                <span class="data-label">Transmission</span>
                                <ul class="data-list">
                                    <?php foreach($routes as $r): ?><li><?php echo htmlspecialchars($r); ?></li><?php endforeach; ?>
                                </ul>
                            </div>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <div class="card metabolite-card">
            <div class="section-title">Metabolites</div>
            <?php if (empty($metabolites)): ?>
                <p class="muted" style="font-size: 13px; margin: 0; color: #aaa;">No metabolite relationships documented for this taxon.</p>
            <?php else: ?>
                <?php
                $met_grouped = [];
                foreach ($metabolites as $met) {
                    $met_grouped[$met['relationship']][] = $met;
                }
                foreach (['produces', 'consumes', 'modifies'] as $rel):
                ?>
                <div class="data-item">
                    <span class="data-label" style="min-width:90px; text-transform:capitalize;"><?php echo $rel; ?></span>
                    <span class="data-value" style="display:flex; flex-wrap:wrap; align-items:center; gap:6px;">
                        <?php if (!empty($met_grouped[$rel])): ?>
                            <?php foreach ($met_grouped[$rel] as $i => $met): ?>
                                <span style="display:inline-flex; align-items:center; gap:4px;">
                                    <?php if (!empty($met['kegg_compound_id'])): ?>
                                        <a href="https://www.genome.jp/entry/<?php echo urlencode($met['kegg_compound_id']); ?>" target="_blank" style="text-decoration:none;">
                                            <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#ffedd5; color:#9a3412; border:1px solid #fdba74; font-family:monospace;"><?php echo htmlspecialchars($met['kegg_compound_id']); ?></span>
                                        </a>
                                    <?php endif; ?>
                                    <?php if (!empty($met['chebi_id'])): ?>
                                        <?php $chebi_num = preg_replace('/^CHEBI:/i', '', $met['chebi_id']); ?>
                                        <a href="https://www.ebi.ac.uk/chebi/searchId.do?chebiId=<?php echo urlencode($met['chebi_id']); ?>" target="_blank" style="text-decoration:none;">
                                            <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#d1fae5; color:#065f46; border:1px solid #6ee7b7; font-family:monospace;"><?php echo htmlspecialchars($chebi_num); ?></span>
                                        </a>
                                    <?php endif; ?>
                                    <span><?php echo htmlspecialchars($met['metabolite_name']); ?></span>
                                </span>
                                <?php if ($i < count($met_grouped[$rel]) - 1): ?><span style="color:#ccc;">·</span><?php endif; ?>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </span>
                </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>

        <div class="card" style="margin-bottom: 0px;">
            <div class="section-title">Clinical Profile</div>
            <div class="two-col-grid">
                <div>
                    <div class="data-item">
                        <span class="data-label">Pathobiont</span>
                        <div class="pb-container">
                            <?php
                            $options = ['yes', 'no', 'context dependent', 'unknown'];
                            foreach ($options as $opt):
                                $isActive = ($taxon['is_pathobiont'] === $opt);
                                $class = 'pb-item' . ($isActive ? ($opt === 'yes' ? ' pb-active-yes' : ($opt === 'context dependent' ? ' pb-active-context' : ' pb-active-other')) : '');
                            ?>
                                <span class="<?php echo $class; ?>"><?php echo htmlspecialchars($opt); ?></span>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <?php if (!empty($roles)): ?>
                        <div class="data-item"><span class="data-label">Clinical Roles</span><span class="data-value"><?php echo htmlspecialchars(implode('; ', $roles)); ?></span></div>
                    <?php endif; ?>
                    <?php if (!empty($specimens)): ?>
                        <div class="data-item"><span class="data-label">Typical Specimen</span><span class="data-value"><?php echo htmlspecialchars(implode('; ', $specimens)); ?></span></div>
                    <?php endif; ?>
                    <?php if (!empty($triggers)): ?>
                        <div class="data-item">
                            <span class="data-label">Bloom Triggers</span>
                            <span class="data-value" style="display:flex; flex-wrap:wrap; gap:6px; align-items:center;">
                                <?php foreach ($triggers as $i => $trig): ?>
                                    <span style="display:inline-flex; align-items:center; gap:4px;">
                                        <?php if (!empty($trig['ext_id'])): ?>
                                            <a href="https://www.kegg.jp/entry/<?php echo htmlspecialchars($trig['ext_id']); ?>" target="_blank" rel="noopener" style="text-decoration:none;">
                                                <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#ffedd5; color:#9a3412; border:1px solid #fdba74; font-family:monospace;"><?php echo htmlspecialchars($trig['ext_id']); ?></span>
                                            </a>
                                        <?php endif; ?>
                                        <?php echo htmlspecialchars($trig['value']); ?>
                                    </span><?php if ($i < count($triggers) - 1): ?><span style="color:#ccc;">·</span><?php endif; ?>
                                <?php endforeach; ?>
                            </span>
                        </div>
                    <?php endif; ?>
                </div>
                <div>
                    <?php if (!empty($risk_groups)): ?>
                        <div class="data-item"><span class="data-label">Risk Contexts</span><span class="data-value"><?php echo htmlspecialchars(implode('; ', $risk_groups)); ?></span></div>
                    <?php endif; ?>
                    <?php if (!empty($amr_alerts)): ?>
                        <div class="data-item">
                            <span class="data-label">AMR Highlights</span>
                            <span class="data-value" style="display:flex; flex-wrap:wrap; gap:6px; align-items:center;">
                                <?php foreach ($amr_alerts as $i => $amr): ?>
                                    <span style="display:inline-flex; align-items:center; gap:4px;">
                                        <?php if (!empty($amr['ext_id'])): ?>
                                            <?php $aro_num = preg_replace('/^ARO:/', '', $amr['ext_id']); ?>
                                            <a href="https://card.mcmaster.ca/ontology/<?php echo htmlspecialchars($aro_num); ?>" target="_blank" rel="noopener" style="text-decoration:none;">
                                                <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; font-family:monospace;"><?php echo htmlspecialchars($aro_num); ?></span>
                                            </a>
                                        <?php endif; ?>
                                        <?php echo htmlspecialchars($amr['value']); ?>
                                    </span><?php if ($i < count($amr_alerts) - 1): ?><span style="color:#ccc;">·</span><?php endif; ?>
                                <?php endforeach; ?>
                            </span>
                        </div>
                    <?php endif; ?>
                    <?php if (!empty($vf_entries)): ?>
                        <div class="data-item">
                            <span class="data-label">Virulence Factors</span>
                            <span class="data-value" style="display:flex; flex-wrap:wrap; gap:6px; align-items:center;">
                                <?php foreach ($vf_entries as $i => $vf): ?>
                                    <span style="display:inline-flex; align-items:center; gap:4px;">
                                        <?php if (!empty($vf['ext_id'])): ?>
                                            <a href="https://www.mgc.ac.cn/cgi-bin/VFs/vfs.cgi?VFID=<?php echo urlencode($vf['ext_id']); ?>" target="_blank" rel="noopener" style="text-decoration:none;">
                                                <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#fce7f3; color:#9d174d; border:1px solid #f9a8d4; font-family:monospace;"><?php echo htmlspecialchars($vf['ext_id']); ?></span>
                                            </a>
                                        <?php endif; ?>
                                        <?php echo htmlspecialchars($vf['value']); ?>
                                    </span><?php if ($i < count($vf_entries) - 1): ?><span style="color:#ccc;">·</span><?php endif; ?>
                                <?php endforeach; ?>
                            </span>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

            <div class="hr-soft" style="margin: 20px 0;"></div>

            <div style="margin-top: 15px;">
                <strong>Clinical Associations:</strong>
                <?php if(!empty($associations)): ?>
                    <?php foreach($associations as $assoc): ?>
                        <?php $ev_level = $assoc['evidence_level']; ?>
                        <div style="display: flex; align-items: flex-start; margin: 10px 0; padding: 12px; background: #fafafa; border-radius: 5px;">
                            <div class="ev-tooltip" style="margin-right: 15px; display: inline-flex; flex-shrink: 0; margin-top: 2px;">
                                <span class="eg-badge eg-<?php echo htmlspecialchars($ev_level); ?>" style="margin-right: 0;"><?php echo htmlspecialchars($ev_level); ?></span>
                                <div class="ev-tooltiptext">
                                    <?php
                                    $grades = [
                                        'E3' => 'E3 — Strong human clinical evidence',
                                        'E2' => 'E2 — Moderate human evidence',
                                        'E1' => 'E1 — Limited / preliminary',
                                    ];
                                    foreach ($grades as $gk => $gl):
                                        $active_class = ($gk === $ev_level) ? 'dict-term dict-term-active' : 'dict-term';
                                    ?>
                                        <span class="<?php echo $active_class; ?>"><?php echo htmlspecialchars($gl); ?></span>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                            <div style="flex-grow: 1;">
                                <div style="font-size: 14px; color: #222; font-weight: 500;"><?php echo htmlspecialchars($assoc['association_text']); ?></div>
                                <?php if (!empty($assoc['clinical_pmids'])): ?>
                                    <div style="font-size: 11px; margin-top: 4px; color: #777;">
                                        <strong>PMID:</strong>
                                        <?php foreach(explode(', ', $assoc['clinical_pmids']) as $cp): ?>
                                            <a href="https://pubmed.ncbi.nlm.nih.gov/<?php echo trim($cp); ?>/" target="_blank" style="text-decoration: underline; margin-right: 8px; color: #007bff;"><?php echo htmlspecialchars(trim($cp)); ?></a>
                                        <?php endforeach; ?>
                                    </div>
                                <?php endif; ?>
                                <?php if (!empty($assoc_refs_map[$assoc['id']])): ?>
                                    <?php
                                    $mesh_refs = [];
                                    $kegg_refs = [];
                                    $other_refs = [];
                                    foreach ($assoc_refs_map[$assoc['id']] as $ref) {
                                        $rt = strtolower($ref['ref_type'] ?? '');
                                        if ($rt === 'mesh')                              $mesh_refs[]  = $ref;
                                        elseif ($rt === 'kegg' || $rt === 'kegg_disease') $kegg_refs[]  = $ref;
                                        else                                              $other_refs[] = $ref;
                                    }
                                    usort($mesh_refs, fn($a, $b) => strcasecmp($a['ref_label'] ?: $a['ref_id'], $b['ref_label'] ?: $b['ref_id']));
                                    usort($kegg_refs, fn($a, $b) => strcasecmp($a['ref_label'] ?: $a['ref_id'], $b['ref_label'] ?: $b['ref_id']));
                                    ?>
                                    <div style="margin-top: 8px; display: flex; flex-wrap: wrap; align-items: center; gap: 8px;">
                                        <?php foreach ($mesh_refs as $ref): ?>
                                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                                <a href="https://meshb.nlm.nih.gov/record/ui?ui=<?php echo urlencode($ref['ref_id']); ?>" target="_blank" class="assoc-ref-tag assoc-ref-mesh"><?php echo htmlspecialchars($ref['ref_id']); ?></a>
                                                <?php if (!empty($ref['ref_label'])): ?>
                                                    <span style="font-size:13px; color:#333;"><?php echo htmlspecialchars($ref['ref_label']); ?></span>
                                                <?php endif; ?>
                                            </span>
                                        <?php endforeach; ?>
                                        <?php foreach ($kegg_refs as $ref): ?>
                                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                                <a href="https://www.genome.jp/entry/<?php echo urlencode($ref['ref_id']); ?>" target="_blank" class="assoc-ref-tag assoc-ref-kegg"><?php echo htmlspecialchars($ref['ref_id']); ?></a>
                                                <?php if (!empty($ref['ref_label'])): ?>
                                                    <span style="font-size:13px; color:#333;"><?php echo htmlspecialchars($ref['ref_label']); ?></span>
                                                <?php endif; ?>
                                            </span>
                                        <?php endforeach; ?>
                                        <?php foreach ($other_refs as $ref): ?>
                                            <span class="assoc-ref-tag assoc-ref-other"><?php echo htmlspecialchars(!empty($ref['ref_label']) ? $ref['ref_label'] : $ref['ref_id']); ?></span>
                                        <?php endforeach; ?>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p class="muted" style="color: #888; font-size: 14px; margin-top: 10px;">No specific clinical associations documented.</p>
                <?php endif; ?>
            </div>


            <div class="hr-soft" style="margin: 20px 0;"></div>

            <div style="display: flex; justify-content: space-between; align-items: center; font-size: 12px;">
                <div>
                    <button type="button" onclick="document.getElementById('dict-modal').style.display='flex'" style="background: #fff; color: #000; border: 1px solid #ccc; padding: 5px 15px; font-size: 11px; font-weight: 800; cursor: pointer; letter-spacing: 1px; border-radius: 3px;">HELP</button>
                </div>
                <div style="color: #aaa;">Last reviewed: <?php echo htmlspecialchars($taxon['last_reviewed']); ?></div>
            </div>
        </div>

        <?php if (!empty($papers)): ?>
        <div class="card" style="margin-top: 24px;">
            <div class="section-title">Evidence Timeline</div>
            <div class="timeline-strip">
                <?php foreach ($papers as $paper): ?>
                    <a href="https://pubmed.ncbi.nlm.nih.gov/<?php echo htmlspecialchars($paper['pmid']); ?>/" target="_blank" class="timeline-card" style="text-decoration: none; color: inherit;">
                        <span class="timeline-year"><?php echo htmlspecialchars($paper['year'] ?: '?'); ?></span>
                        <?php if (!empty($paper['study_design'])): ?>
                            <?php
                            // Truncate at em-dash or long "—" to keep cards compact
                            $sd = $paper['study_design'];
                            foreach (['—', ' — ', ' - '] as $sep) {
                                $pos = mb_strpos($sd, $sep);
                                if ($pos !== false) { $sd = mb_substr($sd, 0, $pos); break; }
                            }
                            ?>
                            <span class="timeline-design"><?php echo htmlspecialchars(trim($sd)); ?></span>
                        <?php endif; ?>
                    </a>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>

        <div class="card" style="margin-top: 24px;">
            <div class="section-title">
                Related Taxa
                <span style="font-size: 11px; font-weight: 400; color: #aaa; text-transform: none; letter-spacing: 0; margin-left: 8px;">
                    <span class="rt-match-niche">Shared Niche</span> = same body site &nbsp;
                    <span class="rt-match-risk">Shared Risk</span> = same vulnerable population
                    <span style="margin-left: 8px; cursor: help; color: #bbb;" title="Risk context: the clinical setting or patient group in which this organism is most likely to cause harm (e.g. ICU, immunocompromised, post-antibiotic).">&#9432;</span>
                </span>
            </div>
            <?php if (!empty($related_taxa)): ?>
                <div class="related-taxa-grid">
                    <?php foreach ($related_taxa as $rt): ?>
                        <?php
                            $cats = explode(',', $rt['match_cats'] ?? '');
                            $has_niche = in_array('primary_niche', $cats);
                            $has_risk  = in_array('risk_context', $cats);
                            $rt_ev     = $rt['top_evidence'] ?? null;
                        ?>
                        <a href="<?php echo $rt['passport_id']; ?>" class="related-taxon-pill" target="_blank">
                            <span class="related-taxon-id"><?php echo htmlspecialchars($rt['passport_id']); ?></span>
                            <div class="rt-name-row">
                                <span class="related-taxon-name"><?php echo htmlspecialchars($rt['preferred_name']); ?></span>
                                <?php if ($has_niche): ?><span class="rt-match-niche">Niche</span><?php endif; ?>
                                <?php if ($has_risk):  ?><span class="rt-match-risk">Risk</span><?php endif; ?>
                            </div>
                        </a>
                    <?php endforeach; ?>
                </div>
            <?php else: ?>
                <p class="muted" style="font-size: 13px; margin: 0; color: #aaa;">No related taxa in current database.</p>
            <?php endif; ?>
        </div>

    <?php else: ?>
        <div class="callout" style="text-align: center; padding: 48px 24px;">
            <h3 style="margin: 0 0 12px; color: #404f7c;">We couldn't find that passport.</h3>
            <p style="color: #666; max-width: 520px; margin: 0 auto 20px; line-height: 1.6;">
                The passport ID
                <?php if (!empty($_GET['id'])): ?>
                    <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; color: #404f7c;"><?= htmlspecialchars($_GET['id']) ?></code>
                <?php else: ?>
                    you requested
                <?php endif; ?>
                isn't in our knowledge base. It may have been retired, or the ID may have a typo.
            </p>
            <p style="margin: 0;">
                <a href="passports.php" style="color: #404f7c; font-weight: bold; text-decoration: none; padding: 8px 18px; border: 1px solid #404f7c; border-radius: 4px; display: inline-block;">Browse all passports</a>
                &nbsp;
                <a href="/" style="color: #404f7c; font-weight: bold; text-decoration: none; padding: 8px 18px; border: 1px solid #404f7c; border-radius: 4px; display: inline-block;">Back to home</a>
            </p>
        </div>
    <?php endif; ?>
</div>

<script>
    const b = document.getElementById('copy-passport-id');
    if (b) {
        b.onclick = () => {
            navigator.clipboard.writeText(window.location.href);
            b.innerText = "COPIED!";
            setTimeout(() => { b.innerText = "<?php echo $taxon['passport_id'] ?? ''; ?>"; }, 1500);
        };
    }
</script>

<div id="dict-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
    <div style="background: #fff; width: 90%; max-width: 950px; height: 85%; border-radius: 6px; position: relative; box-shadow: 0 4px 20px rgba(0,0,0,0.2); overflow: hidden; display: flex; flex-direction: column;">
        <div style="text-align: right; padding: 10px 15px; background: #fafafa; border-bottom: 1px solid #eee;">
            <button onclick="document.getElementById('dict-modal').style.display='none'" style="background: none; border: none; font-size: 20px; font-weight: bold; color: #555; cursor: pointer;">&times;</button>
        </div>
        <iframe src="glossary.php?popup=1" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
</div>
<script>
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') document.getElementById('dict-modal').style.display = 'none';
});
</script>

<?php include 'footer.php'; ?>
