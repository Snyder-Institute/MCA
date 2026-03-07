<?php
require_once 'db_connect.php';

$id = isset($_GET['id']) ? trim($_GET['id']) : '';
if (empty($id)) {
    header("Location: index.php");
    exit;
}

try {
    $stmt = $pdo->prepare("
        SELECT p.passport_id, p.preferred_name, p.lineage, p.ncbi_taxid, p.taxon_rank, 
               p.version, p.is_pathobiont, p.last_reviewed,
               b.gram_status, b.morphology, b.oxygen_tolerance
        FROM mca_taxon_passport p
        LEFT JOIN mca_taxon_biology b ON p.passport_id = b.passport_id
        WHERE p.passport_id = ?
    ");
    $stmt->execute([$id]);
    $taxon = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($taxon) {
        function getList($pdo, $table, $column, $id) {
            $s = $pdo->prepare("SELECT $column FROM $table WHERE passport_id = ?");
            $s->execute([$id]);
            return $s->fetchAll(PDO::FETCH_COLUMN);
        }

        $synonyms    = getList($pdo, 'mca_taxon_synonym', 'synonym', $id);
        
        $traits      = getList($pdo, 'mca_taxon_key_trait', 'trait_text', $id);
        $niches      = getList($pdo, 'mca_taxon_primary_niche', 'niche_text', $id);
        $reservoirs  = getList($pdo, 'mca_taxon_reservoir', 'reservoir_source', $id);
        $routes      = getList($pdo, 'mca_taxon_transmission_route', 'route_text', $id);
        $roles       = getList($pdo, 'mca_taxon_role', 'role_text', $id);
        $amr_alerts  = getList($pdo, 'mca_taxon_amr_highlight', 'highlight_text', $id);
        $triggers    = getList($pdo, 'mca_taxon_bloom_trigger', 'trigger_text', $id);
        $pmids       = getList($pdo, 'mca_taxon_evidence_pmid', 'pmid', $id);
        $specimens   = getList($pdo, 'mca_taxon_typical_specimen', 'specimen_text', $id);
        $risk_groups = getList($pdo, 'mca_taxon_risk_context', 'context_text', $id);

        $assoc_stmt = $pdo->prepare("
            SELECT a.association_id, a.association_text, a.evidence_level, 
                   GROUP_CONCAT(ap.pmid SEPARATOR ', ') as clinical_pmids
            FROM mca_clinical_association a
            LEFT JOIN mca_clinical_association_pmid ap ON a.association_id = ap.association_id
            WHERE a.passport_id = ?
            GROUP BY a.association_id
        ");
        $assoc_stmt->execute([$id]);
        $associations = $assoc_stmt->fetchAll(PDO::FETCH_ASSOC);
        
        $formatted_lineage = str_replace('|', ' | ', $taxon['lineage'] ?? 'n/a');
    }
} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
}

include 'header.php'; 
?>

<style>
    .passport-header { border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
    .grid-2-cols { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 50px; }
    .section-title { font-size: 12px; text-transform: uppercase; letter-spacing: 1.5px; color: #888; margin-bottom: 15px; font-weight: 800; border-bottom: 1px solid #eee; padding-bottom: 5px; }
    
    .data-item { margin-bottom: 12px; display: flex; align-items: flex-start; }
    .data-label { font-weight: 700; color: #111; font-size: 13px; width: 140px; flex-shrink: 0; }
    .data-value { color: #444; font-size: 14px; line-height: 1.5; flex-grow: 1; }
    
    .data-list { margin: 0; padding-left: 18px; list-style-type: disc; color: #555; font-size: 14px; }
    .data-list li { margin-bottom: 4px; line-height: 1.4; }

    .eg-badge { display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border-radius: 4px; font-weight: 900; font-size: 11px; margin-right: 15px; flex-shrink: 0; }
    .eg-E3 { background: #fee2e2; color: #b91c1c; border: 1px solid #f87171; }
    .eg-E2 { background: #fef3c7; color: #92400e; border: 1px solid #fbbf24; }
    .eg-E1 { background: #f0fdf4; color: #166534; border: 1px solid #4ade80; }

    .pb-container { display: flex; gap: 6px; flex-wrap: wrap; }
    .pb-item { padding: 3px 8px; border-radius: 3px; font-weight: bold; font-size: 9px; text-transform: uppercase; background: #f5f5f5; color: #ccc; border: 1px solid #eee; }
    .pb-active-yes { background: #007bff !important; color: #fff !important; border-color: #0056b3 !important; }
    .pb-active-other { background: #444 !important; color: #fff !important; border-color: #222 !important; }

    .ev-tooltip { position: relative; display: inline-block; cursor: help; }
    .ev-tooltip .ev-tooltiptext {
        visibility: hidden; width: 260px; background-color: #fff; color: #333; text-align: left;
        border: 1px solid #ccc; border-radius: 4px; padding: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        position: absolute; z-index: 10; bottom: 150%; left: 50%; transform: translateX(-50%);
        opacity: 0; transition: opacity 0.2s;
    }
    .ev-tooltip .ev-tooltiptext .dict-term { font-weight: 800; font-size: 13px; color: #000; display: block; }
    .ev-tooltip:hover .ev-tooltiptext { visibility: visible; opacity: 1; }
</style>

<div class="page-content">
    <div style="margin-bottom: 20px;">
        <a href="index.php" style="font-weight: bold; font-size: 12px; color: #000; text-decoration: none; letter-spacing: 1px;">&larr; BACK TO HOME</a>
    </div>

    <?php if ($taxon): ?>
        <div class="passport-header">
            <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <h1 style="margin: 0; font-size: 42px; font-style: italic; color: #000; line-height: 1;">
                        <?php echo htmlspecialchars($taxon['preferred_name']); ?>
                    </h1>
                    <div style="margin-top: 12px; font-size: 14px; color: #777;">
                        <?php echo htmlspecialchars($formatted_lineage); ?>
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
                        TaxID: <a href="https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=<?php echo $taxon['ncbi_taxid']; ?>" target="_blank" style="color:#000; font-weight:bold; text-decoration: none;"> <?php echo htmlspecialchars($taxon['ncbi_taxid']); ?></a> 
                        | Rank: <span style="text-transform: capitalize; color: #000; font-weight: bold;"> <?php echo htmlspecialchars($taxon['taxon_rank']); ?></span> 
                        | Version: <strong style="color: #000;"> <?php echo htmlspecialchars($taxon['version']); ?></strong>
                    </div>
                </div>
            </div>
        </div>

        <div class="grid-2-cols">
            <div class="card">
                <div class="section-title">Biology</div>
                <div class="data-item"><span class="data-label">Gram Status</span><span class="data-value"><?php echo htmlspecialchars($taxon['gram_status'] ?? 'unknown'); ?></span></div>
                <div class="data-item"><span class="data-label">Oxygen Tolerance</span><span class="data-value"><?php echo htmlspecialchars($taxon['oxygen_tolerance'] ?? 'n/a'); ?></span></div>
                <div class="data-item"><span class="data-label">Morphology</span><span class="data-value"><?php echo htmlspecialchars($taxon['morphology'] ?? 'n/a'); ?></span></div>
                <div class="data-item">
                    <span class="data-label">Key Traits</span>
                    <ul class="data-list">
                        <?php foreach($traits as $t): ?><li><?php echo htmlspecialchars($t); ?></li><?php endforeach; ?>
                    </ul>
                </div>
            </div>

            <div class="card">
                <div class="section-title">Ecology</div>
                <div class="data-item"><span class="data-label">Primary Niches</span><span class="data-value"><?php echo !empty($niches) ? implode(', ', $niches) : 'n/a'; ?></span></div>
                <div class="data-item"><span class="data-label">Reservoir</span><span class="data-value"><?php echo !empty($reservoirs) ? implode(', ', $reservoirs) : 'n/a'; ?></span></div>
                <div class="data-item">
                    <span class="data-label">Transmission</span>
                    <ul class="data-list">
                        <?php foreach($routes as $r): ?><li><?php echo htmlspecialchars($r); ?></li><?php endforeach; ?>
                    </ul>
                </div>
            </div>
        </div>

        <div class="card" style="margin-bottom: 0px;">
            <div class="section-title">Clinical Profile</div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                <div>
                    <div class="data-item">
                        <span class="data-label">Pathobiont</span>
                        <div class="pb-container">
                            <?php 
                            $options = ['yes', 'no', 'context dependent', 'unknown'];
                            foreach ($options as $opt): 
                                $isActive = ($taxon['is_pathobiont'] === $opt);
                                $class = 'pb-item' . ($isActive ? ($opt === 'yes' ? ' pb-active-yes' : ' pb-active-other') : '');
                            ?>
                                <span class="<?php echo $class; ?>"><?php echo htmlspecialchars($opt); ?></span>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <div class="data-item"><span class="data-label">Clinical Roles</span><span class="data-value"><?php echo !empty($roles) ? implode('; ', $roles) : 'n/a'; ?></span></div>
                    <div class="data-item"><span class="data-label">Typical Specimen</span><span class="data-value"><?php echo !empty($specimens) ? implode('; ', $specimens) : 'n/a'; ?></span></div>
                    <div class="data-item"><span class="data-label">Antimicrobial Resistance</span><span class="data-value"><?php echo !empty($amr_alerts) ? implode('; ', $amr_alerts) : 'None'; ?></span></div>
                </div>
                <div>
                    <div class="data-item"><span class="data-label">Bloom Triggers</span><span class="data-value"><?php echo !empty($triggers) ? implode('; ', $triggers) : 'n/a'; ?></span></div>
                    <div class="data-item"><span class="data-label">Risk Contexts</span><span class="data-value"><?php echo !empty($risk_groups) ? implode('; ', $risk_groups) : 'n/a'; ?></span></div>
                </div>
            </div>

            <div class="hr-soft" style="margin: 20px 0;"></div>
            
            <div style="margin-top: 15px;">
                <strong>Clinical Associations:</strong>
                <?php if(!empty($associations)): ?>
                    <?php foreach($associations as $assoc): ?>
                        <?php
                        $ev_level = $assoc['evidence_level'];
                        $ev_tooltip_html = '<span class="dict-term">E3 — Strong human clinical evidence</span><span class="dict-term">E2 — Moderate human evidence</span><span class="dict-term">E1 — Limited / preliminary</span>';
                        ?>
                        <div style="display: flex; align-items: center; margin: 10px 0; padding: 12px; background: #fafafa; border-radius: 5px;">
                            <div class="ev-tooltip" style="margin-right: 15px; display: inline-flex;">
                                <span class="eg-badge eg-<?php echo htmlspecialchars($ev_level); ?>" style="margin-right: 0;"><?php echo htmlspecialchars($ev_level); ?></span>
                                <?php if ($ev_tooltip_html !== ''): ?>
                                    <div class="ev-tooltiptext"><?php echo $ev_tooltip_html; ?></div>
                                <?php endif; ?>
                            </div>
                            <div style="flex-grow: 1;">
                                <div style="font-size: 14px; color: #222; font-weight: 500;"><?php echo htmlspecialchars($assoc['association_text']); ?></div>
                                <?php if (!empty($assoc['clinical_pmids'])): ?>
                                    <div style="font-size: 11px; margin-top: 4px; color: #777;">
                                        <strong>PMID:</strong> 
                                        <?php 
                                        $cp_list = explode(', ', $assoc['clinical_pmids']);
                                        foreach($cp_list as $cp): ?>
                                            <a href="https://pubmed.ncbi.nlm.nih.gov/<?php echo trim($cp); ?>/" target="_blank" style="text-decoration: underline; margin-right: 8px; color: #007bff;"><?php echo htmlspecialchars(trim($cp)); ?></a> 
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

    <?php else: ?>
        <div class="callout"><h3>Record not found</h3></div>
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

<?php include 'footer.php'; ?>