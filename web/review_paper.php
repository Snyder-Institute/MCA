<?php
/**
 * review_paper.php — per-paper voting page.
 *
 * Sections, top → bottom:
 *   1. Header bar — back link · paper title · Submit button (right)
 *   2. Paper meta — authors · italicized journal · (year) · Open in PDF · View on PubMed
 *                   plus study design and sample size on a second line
 *   3. Abstract (labeled)
 *   4. Reviewer guideline
 *   5. Clinical association cards: claim · supporting PMIDs · ontology refs ·
 *      Evidence row · Quality row · Comment box
 *   6. Curated context for these claims (always fully expanded)
 */

declare(strict_types=1);
require_once __DIR__ . '/review_auth.php';

$pmid = isset($_GET['pmid']) ? (int) $_GET['pmid'] : 0;
if ($pmid <= 0) { http_response_code(400); exit('Bad request'); }

$stmt = $pdo_review->prepare(
    'SELECT status, context_comment FROM review_paper WHERE token = :t AND pmid = :p LIMIT 1'
);
$stmt->execute(['t' => $review_token, 'p' => $pmid]);
$rp = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$rp) { http_response_code(404); exit('Paper not in your review queue'); }
$readonly = ($rp['status'] === 'frozen');
$context_comment = $rp['context_comment'] ?? '';

$stmt = $pdo_review->prepare(
    'SELECT * FROM paper_snapshot WHERE pmid = :p LIMIT 1'
);
$stmt->execute(['p' => $pmid]);
$paper = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$paper) { http_response_code(404); exit('Paper not found'); }

$stmt = $pdo_review->prepare(
    "SELECT a.association_uid, a.taxon_name, a.taxon_rank,
            a.association_text, a.evidence_level, a.supporting_pmids,
            a.assoc_refs_json, a.context_json,
            v.evidence_vote, v.text_vote, v.comment
     FROM association_snapshot a
     LEFT JOIN review_vote v
            ON v.association_uid = a.association_uid AND v.token = :t
     WHERE a.pmid = :p
     ORDER BY FIELD(a.evidence_level, 'E3', 'E2', 'E1', 'UNCERTAIN'),
              a.taxon_name, a.association_uid"
);
$stmt->execute(['t' => $review_token, 'p' => $pmid]);
$associations = $stmt->fetchAll(PDO::FETCH_ASSOC);

$h = fn($s) => htmlspecialchars((string) $s, ENT_QUOTES);

$contexts_by_taxon = [];
foreach ($associations as $a) {
    if (!isset($contexts_by_taxon[$a['taxon_name']])) {
        $contexts_by_taxon[$a['taxon_name']] = json_decode($a['context_json'] ?? 'null', true);
    }
}

/**
 * Resolve an outbound link for an ontology ID. Returns href or null if unknown.
 */
function ext_url(string $kind, ?string $id): ?string
{
    if (!$id) return null;
    switch ($kind) {
        case 'mesh':
            // Strip leading "MESH:" if present
            $id = preg_replace('/^MESH:/i', '', $id);
            return 'https://meshb.nlm.nih.gov/record/ui?ui=' . rawurlencode($id);
        case 'kegg':           // any KEGG entry — H/D/C/etc.
        case 'kegg_disease':
        case 'kegg_drug':
        case 'kegg_compound':
            return 'https://www.kegg.jp/entry/' . rawurlencode($id);
        case 'chebi':
            // Accept "CHEBI:30089" or bare "30089"
            $cid = preg_replace('/^CHEBI:/i', '', $id);
            return 'https://www.ebi.ac.uk/chebi/searchId.do?chebiId=CHEBI:' . rawurlencode($cid);
        case 'aro':
            // ARO:3004306 -> 3004306
            $aro = preg_replace('/^ARO:/i', '', $id);
            return 'https://card.mcmaster.ca/ontology/' . rawurlencode($aro);
        case 'ncbi_taxid':
            return 'https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=' . rawurlencode($id);
        default:
            return null;
    }
}

/**
 * Render an outbound-link button for an ontology ID. Returns HTML.
 * If no resolver is known, returns a styled pill without a link.
 */
function id_button(string $kind, string $id): string
{
    $h = fn($s) => htmlspecialchars((string) $s, ENT_QUOTES);
    $url = ext_url($kind, $id);
    $cls_map = [
        'mesh'          => 'mesh',
        'kegg'          => 'kegg',
        'kegg_disease'  => 'kegg',
        'kegg_drug'     => 'kegg',
        'kegg_compound' => 'kegg',
        'aro'           => 'aro',
        'chebi'         => 'chebi',
    ];
    $cls = $cls_map[$kind] ?? 'mesh';
    // Strip the kind's prefix from the displayed text so the button reads as a
    // bare ID (e.g. "CHEBI:17012" -> "17012", "ARO:3004306" -> "3004306"). The
    // outbound link still uses the full prefixed form.
    $display = $id;
    if ($kind === 'chebi') $display = preg_replace('/^CHEBI:/i', '', $id);
    if ($kind === 'aro')   $display = preg_replace('/^ARO:/i',   '', $id);
    if ($url) {
        return sprintf(
            '<a href="%s" target="_blank" rel="noopener" class="id-btn %s">%s</a>',
            $h($url), $h($cls), $h($display)
        );
    }
    return sprintf('<span class="id-btn %s">%s</span>', $h($cls), $h($display));
}

/**
 * Render a list of items where each item is either a string or a dict
 * with optional ontology IDs. `id_keys` is a list of (key, link-kind)
 * pairs to probe in the dict for outbound buttons.
 *
 * Output format per item:
 *     "[ID-button] - value"        (if any id resolves)
 *     "value"                       (plain string item)
 */
function render_list(array $items, array $id_keys = []): string
{
    if (!$items) return '';
    $h = fn($s) => htmlspecialchars((string) $s, ENT_QUOTES);
    $parts = [];
    foreach ($items as $it) {
        if (is_string($it)) {
            $parts[] = $h($it);
            continue;
        }
        if (!is_array($it)) continue;
        $label = $it['value'] ?? $it['label'] ?? json_encode($it);
        $btn = '';
        foreach ($id_keys as [$key, $kind]) {
            if (!empty($it[$key])) {
                $btn = id_button($kind, (string) $it[$key]);
                break;  // one id per item
            }
        }
        $parts[] = $btn === '' ? $h($label) : $btn . ' - ' . $h($label);
    }
    return implode(', ', $parts);
}

function render_kv(string $label, string $rendered): string
{
    if ($rendered === '') return '';
    return sprintf('<div><span class="ctx-label">%s</span> %s</div>',
                   htmlspecialchars($label), $rendered);
}

$pdf_url = 'review_pdf.php?t=' . urlencode($review_token) . '&pmid=' . $pmid;

?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="robots" content="noindex, nofollow">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MCA Review — PMID <?= $pmid ?></title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
         margin: 0; padding: 24px; max-width: 920px; margin: 0 auto; color: #222; }
  a { color: #404f7c; }
  .topbar { display: flex; justify-content: space-between; align-items: flex-start;
            gap: 20px; margin-bottom: 6px; }
  .topbar .left { flex: 1; min-width: 0; }
  .back-link { color: #888; font-size: 13px; text-decoration: none; }
  .back-link:hover { text-decoration: underline; }
  h1 { font-size: 22px; line-height: 1.3; margin: 6px 0 8px; }
  h2 { font-size: 16px; margin: 28px 0 12px; padding-bottom: 6px;
       border-bottom: 1px solid #eee; color: #555; font-weight: 600; }
  .submit-row { text-align: center; margin: 16px 0 32px; }
  .guidelines-details { margin: 24px 0 12px; }
  .guidelines-details > summary { font-size: 13px; color: #888;
       cursor: pointer; padding: 6px 0; list-style: none; user-select: none; }
  .guidelines-details > summary::-webkit-details-marker { display: none; }
  .guidelines-details > summary::before { content: '▸ '; color: #aaa;
       font-size: 11px; transition: transform 0.15s; display: inline-block; }
  .guidelines-details[open] > summary::before { transform: rotate(90deg); }
  .guidelines-details[open] > summary { color: #404f7c; }
  .guidelines-details > summary:hover { color: #404f7c; }
  .guidelines-details[open] > .guideline { margin-top: 8px; }
  .hl-summary { background: #fff8e1; color: #92400e; padding: 2px 5px;
                border-radius: 3px; font-weight: 500; }
  .thanks { margin: 48px 0 80px; padding: 22px 24px; text-align: center;
            color: #555; font-size: 14px; line-height: 1.6;
            background: #f8f9fa; border-radius: 8px; border: 1px solid #eee; }
  .thanks p { margin: 0 0 10px; }
  .thanks p:last-child { margin-bottom: 0; }
  .thanks strong { color: #404f7c; }
  .meta { color: #666; font-size: 14px; margin-bottom: 8px; }
  .meta-line2 { color: #888; font-size: 13px; margin-bottom: 14px; }
  .meta a { color: #007bff; text-decoration: none; }
  .meta a:hover { text-decoration: underline; }
  .meta em { font-style: italic; }
  .abstract { background: #fafafa; border: 1px solid #eee; padding: 14px 18px;
              border-radius: 6px; font-size: 14px; line-height: 1.55; color: #444; }
  .abstract.empty { color: #999; font-style: italic; }
  .abstract-label { font-weight: 600; color: #444; margin-bottom: 6px; font-size: 13px;
                    letter-spacing: 0.3px; text-transform: uppercase; }
  .guideline { background: #fff8e1; border-left: 3px solid #fbbf24; padding: 14px 18px;
               margin: 22px 0 12px; font-size: 13.5px; line-height: 1.55; color: #555; }
  .guideline strong { color: #92400e; }
  .guideline p { margin: 0 0 10px; }
  .guideline p:last-child { margin-bottom: 0; }
  .guideline .g-section-title { margin-top: 14px; font-weight: 600; color: #92400e;
                                font-size: 13.5px; }
  .guideline .g-list { margin: 4px 0 8px 0; padding-left: 22px; }
  .guideline .g-list li { margin-bottom: 4px; }
  .card { border: 1px solid #e0e0e0; border-radius: 8px; padding: 16px 18px;
          margin-bottom: 14px; background: #fff; }
  .taxon { font-weight: 600; color: #404f7c; font-size: 14px; }
  .rank  { color: #888; font-size: 12px; margin-left: 6px; }
  .claim { font-size: 15px; line-height: 1.55; margin: 8px 0 12px; }
  .pmids, .refs { font-size: 12px; color: #666; margin-bottom: 8px; }
  .pmids a, .ext { color: #007bff; }
  .id-btn { display: inline-block; padding: 1px 7px; border-radius: 3px;
            font-size: 11px; line-height: 1.5; text-decoration: none;
            border: 1px solid; margin-right: 2px;
            background: #d1fae5; color: #065f46; border-color: #6ee7b7; }
  .id-btn.kegg  { background: #ffedd5; color: #9a3412; border-color: #fdba74; }
  .id-btn.aro   { background: #fee2e2; color: #991b1b; border-color: #fca5a5; }
  .id-btn.chebi { background: #dbeafe; color: #1e40af; border-color: #93c5fd; }
  .id-btn:hover { text-decoration: underline; }
  .row { display: flex; gap: 8px; align-items: center; margin: 6px 0; flex-wrap: wrap; }
  .row-label { font-size: 12px; color: #777; min-width: 90px; }
  .btn { padding: 6px 12px; font-size: 13px; border: 1px solid #ccc;
         background: #fff; color: #333; border-radius: 4px; cursor: pointer;
         font-family: inherit; }
  .btn:hover { background: #f5f5f5; }
  .btn.active { background: #404f7c; color: #fff; border-color: #404f7c; }
  .btn[disabled] { opacity: 0.6; cursor: not-allowed; }
  .selected-tag { font-size: 11px; color: #0a7; margin-left: 10px;
                  font-weight: 600; opacity: 0; transition: opacity 0.2s; }
  .selected-tag.show { opacity: 1; }
  .comment-row { margin-top: 10px; }
  .comment-row label { font-size: 12px; color: #777; display: block; margin-bottom: 4px; }
  .comment-row textarea { width: 100%; box-sizing: border-box; min-height: 50px;
                          font-family: inherit; font-size: 13px; padding: 8px;
                          border: 1px solid #ddd; border-radius: 4px; resize: vertical; }
  .comment-row textarea:focus { outline: 2px solid #404f7c; outline-offset: -1px; border-color: #404f7c; }
  .ctx { background: #fafafa; border: 1px solid #eee; padding: 14px 18px;
         border-radius: 6px; font-size: 13px; line-height: 1.6; color: #444; }
  .ctx-block { margin-bottom: 10px; }
  .ctx-block-label { font-weight: 600; color: #555; margin-bottom: 4px;
                     text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; }
  .ctx-label { color: #888; min-width: 110px; display: inline-block; }
  .submit-btn { padding: 10px 20px; font-size: 13px; background: #404f7c;
                color: #fff; border: none; border-radius: 4px; cursor: pointer;
                font-family: inherit; white-space: nowrap; flex-shrink: 0; }
  .submit-btn:hover { background: #2f3b5e; }
  .submit-btn.done { background: #0a7; }
  .frozen-banner { background: #fef3c7; border: 1px solid #fbbf24; color: #92400e;
                   padding: 10px 14px; border-radius: 6px; margin-bottom: 20px;
                   font-size: 13px; }
</style>
</head>
<body data-token="<?= $h($review_token) ?>" data-pmid="<?= $pmid ?>">

<?php if ($readonly): ?>
<div class="frozen-banner">
    Voting is now closed — your selections have been preserved. This page is read-only.
</div>
<?php endif ?>

<div class="topbar">
    <div class="left">
        <a href="review.php?t=<?= urlencode($review_token) ?>" class="back-link">← Back to paper list</a>
        <h1><?= $h($paper['title']) ?></h1>
    </div>
</div>

<div class="meta">
    <?= $h($paper['authors']) ?><br>
    <?php if ($paper['journal']): ?><em><?= $h($paper['journal']) ?></em><?php endif ?>
    <?php if ($paper['year']): ?> (<?= $h($paper['year']) ?>)<?php endif ?>
    · <a href="<?= $h($pdf_url) ?>" target="_blank" rel="noopener">Open PDF</a>
    · <a href="https://pubmed.ncbi.nlm.nih.gov/<?= $pmid ?>" target="_blank" rel="noopener">View on PubMed</a>
</div>

<div class="abstract-label" style="margin-top: 22px;">Abstract</div>
<div class="abstract <?= $paper['abstract'] ? '' : 'empty' ?>">
    <?= $paper['abstract']
        ? $h($paper['abstract'])
        : 'Abstract not available — open the PDF or view on PubMed.' ?>
</div>

<?php if (!$readonly): ?>
<div class="submit-row">
    <button class="submit-btn <?= $rp['status'] === 'submitted' ? 'done' : '' ?>" id="submit-btn">
        <?= $rp['status'] === 'submitted' ? '✓ Submitted (re-submit)' : 'Submit this paper' ?>
    </button>
</div>
<?php endif ?>

<h2>Clinical associations <span style="color:#888; font-weight:400;">(<?= count($associations) ?>)</span></h2>

<?php foreach ($associations as $a):
    $uid = $a['association_uid'];
    $curated_e = $a['evidence_level'];   // E1/E2/E3/UNCERTAIN
    // Pre-fill button: reviewer's previous vote, else fall back to the
    // curator's grade (mapping UNCERTAIN -> UNDETERMINED for clarity).
    $current_e = $a['evidence_vote']
                 ?? ($curated_e === 'UNCERTAIN' ? 'UNDETERMINED' : $curated_e);
    $current_t = $a['text_vote'];
    $current_c = $a['comment'];
    $pmids = array_filter(explode(',', $a['supporting_pmids'] ?? ''));
    $refs = json_decode($a['assoc_refs_json'] ?? '[]', true) ?: [];
    // Pre-show "selected" if this card already has any reviewer input.
    $has_input = ($a['evidence_vote'] !== null || $current_t !== null
                  || ($current_c !== null && $current_c !== ''));
?>
<div class="card" data-uid="<?= $h($uid) ?>">
    <div>
        <span class="taxon"><?= $h($a['taxon_name']) ?></span>
        <?php if ($a['taxon_rank']): ?>
            <span class="rank"><?= $h($a['taxon_rank']) ?></span>
        <?php endif ?>
    </div>
    <div class="claim"><?= $h($a['association_text']) ?></div>

    <?php if ($pmids): ?>
    <div class="pmids">
        Supporting PMIDs:
        <?php foreach ($pmids as $i => $p): ?>
            <a href="https://pubmed.ncbi.nlm.nih.gov/<?= (int) $p ?>" target="_blank" rel="noopener"><?= (int) $p ?></a><?= $i < count($pmids) - 1 ? ',' : '' ?>
        <?php endforeach ?>
    </div>
    <?php endif ?>

    <?php if ($refs): ?>
    <div class="refs">
        <?php
        $ref_html = [];
        foreach ($refs as $r) {
            $rt = $r['ref_type'] ?? '';
            $rid = $r['ref_id'] ?? '';
            $rl = $r['ref_label'] ?? '';
            if ($rid === '') continue;
            $btn = id_button($rt, $rid);
            $ref_html[] = $btn . ($rl ? ' - ' . $h($rl) : '');
        }
        echo implode(', ', $ref_html);
        ?>
    </div>
    <?php endif ?>

    <div class="row">
        <span class="row-label">Evidence:</span>
        <?php foreach (['E3','E2','E1','UNDETERMINED'] as $opt):
            $disp = $opt === 'UNDETERMINED' ? 'Undetermined' : $opt;
            $is_active = ($current_e === $opt);
        ?>
            <button class="btn ev-btn <?= $is_active ? 'active' : '' ?>"
                    data-vote="<?= $h($opt) ?>"
                    <?= $readonly ? 'disabled' : '' ?>><?= $h($disp) ?></button>
        <?php endforeach ?>
    </div>

    <div class="row">
        <span class="row-label">Quality:</span>
        <?php foreach ([
            'accurate'    => 'Accurate',
            'overstated'  => 'Overstated',
            'understated' => 'Understated',
            'unsure'      => 'Unsure',
        ] as $val => $label):
            $is_active = ($current_t === $val);
        ?>
            <button class="btn tx-btn <?= $is_active ? 'active' : '' ?>"
                    data-vote="<?= $h($val) ?>"
                    <?= $readonly ? 'disabled' : '' ?>><?= $h($label) ?></button>
        <?php endforeach ?>
        <span class="selected-tag <?= $has_input ? 'show' : '' ?>">selected</span>
    </div>

    <div class="comment-row">
        <label>Comment (optional):</label>
        <textarea class="cmt-input"
                  placeholder="Anything you'd like to share with us about this claim — your insight is genuinely appreciated."
                  <?= $readonly ? 'disabled' : '' ?>><?= $h($current_c ?? '') ?></textarea>
    </div>
</div>
<?php endforeach ?>

<details id="guidelines-details" class="guidelines-details">
    <summary><span class="hl-summary">Show reviewer guidelines</span></summary>
<div class="guideline">
    <p>
        The <strong>clinical associations</strong> above were extracted from the paper by
        an AI curation pipeline (<?= count($associations) ?> claim<?= count($associations) === 1 ? '' : 's' ?>
        for this paper). For each one, please assess:
        (1) the <strong>statement itself and MeSH/KEGG annotations</strong> (you may polish it),
        (2) the <strong>evidence level</strong> the AI assigned (you may pick a different one), and
        (3) the <strong>quality</strong> of the curated text (Accurate / Overstated / Understated).
        Use the <strong>comment box</strong> if you want to leave a note. When you have
        reviewed every claim for this paper, click <strong>Submit this paper</strong>
        just above the claim list to finalize.
    </p>

    <p class="g-section-title">Evidence level</p>
    <p>How strongly the cited paper(s) support the claim — judged by study type, scale, and clinical relevance.</p>
    <ul class="g-list">
        <li><strong>E3 — Strong</strong>: clinical practice guidelines, meta-analyses, systematic reviews, or multiple independent human cohorts presented within a single paper.</li>
        <li><strong>E2 — Moderate</strong>: a single human cohort, a single randomised controlled trial, a case-control study, or a cross-sectional human study.</li>
        <li><strong>E1 — Limited / preliminary</strong>: animal models, in vitro studies, case reports, or mechanistic work without human-cohort confirmation.</li>
        <li><strong>Undetermined</strong>: you cannot tell from the paper which level applies, or the cited evidence is too ambiguous to grade.</li>
    </ul>

    <p class="g-section-title">Quality of the curated statement</p>
    <p>How faithfully the AI-written statement reflects what the paper actually says.</p>
    <ul class="g-list">
        <li><strong>Accurate</strong>: the statement matches the paper's claims and scope. Nothing added, nothing weakened.</li>
        <li><strong>Overstated</strong>: the statement claims more than the paper supports — wider population, stronger causality, more certainty, or broader scope than the original.</li>
        <li><strong>Understated</strong>: the statement claims less than the paper supports — leaves out a stronger finding, narrows a population, or softens a clearly established result.</li>
        <li><strong>Unsure</strong>: you cannot confidently judge whether the wording is accurate, overstated, or understated. Pick this rather than guessing — it is a valid answer.</li>
    </ul>

    <p style="margin-top: 12px;">
        If something is wrong with the cited PMIDs or the MeSH/KEGG annotations, please flag it in the
        comment box — those edits happen during curator adjudication, not on this page.
    </p>
</div>
</details>

<h2>Curated context for these claims</h2>

<?php foreach ($contexts_by_taxon as $taxon => $ctx):
    if (!$ctx) continue;
    $identity = $ctx['identity'] ?? null;
    $bio = $ctx['biology'] ?? null;
    $eco = $ctx['ecology'] ?? null;
    $cp = $ctx['clinical_profile'] ?? null;
    $met = $ctx['metabolites'] ?? null;
?>
<div class="ctx" style="margin-bottom: 14px;">
    <div style="font-weight:600; color:#404f7c; margin-bottom:10px; font-size:14px;">
        <?= $h($taxon) ?>
    </div>

    <?php if ($identity): ?>
    <div class="ctx-block">
        <div class="ctx-block-label">Identity</div>
        <?php if (!empty($identity['domain'])): ?><?= render_kv('Domain', $h($identity['domain'])) ?><?php endif ?>
        <?php if (!empty($identity['lineage'])): ?><?= render_kv('Lineage', $h($identity['lineage'])) ?><?php endif ?>
        <?php if (!empty($identity['ncbi_taxid'])):
            $url = ext_url('ncbi_taxid', (string) $identity['ncbi_taxid']);
            $rendered = sprintf('<a href="%s" target="_blank" rel="noopener" class="ext">%s</a>',
                                $h($url), $h((string) $identity['ncbi_taxid']));
            echo render_kv('NCBI taxid', $rendered);
        endif ?>
        <?php if (!empty($identity['synonyms'])): ?><?= render_kv('Synonyms', render_list($identity['synonyms'])) ?><?php endif ?>
    </div>
    <?php endif ?>

    <?php if ($bio): ?>
    <div class="ctx-block">
        <div class="ctx-block-label">Biology</div>
        <?php if (!empty($bio['gram_status'])): ?><?= render_kv('Gram', $h($bio['gram_status'])) ?><?php endif ?>
        <?php if (!empty($bio['oxygen_tolerance'])): ?><?= render_kv('Oxygen', $h($bio['oxygen_tolerance'])) ?><?php endif ?>
        <?php if (!empty($bio['morphology'])): ?><?= render_kv('Morphology', $h($bio['morphology'])) ?><?php endif ?>
        <?php if (!empty($bio['key_traits'])): ?><?= render_kv('Key traits', render_list($bio['key_traits'])) ?><?php endif ?>
    </div>
    <?php endif ?>

    <?php if ($eco): ?>
    <div class="ctx-block">
        <div class="ctx-block-label">Ecology</div>
        <?php if (!empty($eco['primary_niches'])): ?>
            <?= render_kv('Niches', render_list($eco['primary_niches'], [['mesh_anatomy_id', 'mesh']])) ?>
        <?php endif ?>
        <?php if (!empty($eco['reservoirs'])): ?><?= render_kv('Reservoirs', render_list($eco['reservoirs'])) ?><?php endif ?>
        <?php if (!empty($eco['transmission_routes'])): ?><?= render_kv('Transmission', render_list($eco['transmission_routes'])) ?><?php endif ?>
    </div>
    <?php endif ?>

    <?php if ($cp): ?>
    <div class="ctx-block">
        <div class="ctx-block-label">Clinical profile</div>
        <?php if (!empty($cp['is_pathobiont'])): ?><?= render_kv('Pathobiont', $h($cp['is_pathobiont'])) ?><?php endif ?>
        <?php if (!empty($cp['clinical_roles'])): ?><?= render_kv('Roles', render_list($cp['clinical_roles'])) ?><?php endif ?>
        <?php if (!empty($cp['typical_specimens'])): ?>
            <?= render_kv('Specimens', render_list($cp['typical_specimens'], [['mesh_anatomy_id', 'mesh']])) ?>
        <?php endif ?>
        <?php if (!empty($cp['bloom_triggers'])): ?>
            <?= render_kv('Bloom triggers', render_list($cp['bloom_triggers'], [['kegg_drug_id', 'kegg']])) ?>
        <?php endif ?>
        <?php if (!empty($cp['risk_contexts'])): ?>
            <?= render_kv('Risk contexts', render_list($cp['risk_contexts'], [['mesh_disease_id', 'mesh'], ['kegg_disease_id', 'kegg']])) ?>
        <?php endif ?>
        <?php if (!empty($cp['amr_highlights'])): ?>
            <?= render_kv('AMR', render_list($cp['amr_highlights'], [['aro_id', 'aro']])) ?>
        <?php endif ?>
    </div>
    <?php endif ?>

    <?php if ($met): ?>
    <div class="ctx-block">
        <div class="ctx-block-label">Metabolites</div>
        <?php foreach ($met as $m):
            $name  = $m['metabolite_name'] ?? '';
            $rel   = ucfirst($m['relationship'] ?? '');
            $kegg  = $m['kegg_compound_id'] ?? null;
            $chebi = $m['chebi_id'] ?? null;
            $btns = [];
            if ($kegg)  $btns[] = id_button('kegg',  (string) $kegg);
            if ($chebi) $btns[] = id_button('chebi', (string) $chebi);
            $value = $btns ? implode(' ', $btns) . ' - ' . $h($name) : $h($name);
            echo render_kv($rel, $value);
        endforeach ?>
    </div>
    <?php endif ?>
</div>
<?php endforeach ?>

<div class="comment-row" style="margin-top: 20px;">
    <label><strong>Comment on the curated context (optional)</strong></label>
    <textarea id="ctx-comment-input"
              placeholder="If anything in the context above looks off or worth a second look, please let us know — we're grateful for any thoughts you have."
              <?= $readonly ? 'disabled' : '' ?>><?= $h($context_comment) ?></textarea>
</div>

<div class="thanks">
    <p><strong>Thank you for your time.</strong></p>
    <p>
        Your careful reading and judgment make the Microbial Clinical Atlas more reliable for
        every clinician and researcher who depends on it. We deeply appreciate the expertise you
        are sharing with the community.
    </p>
    <p>
        Once you have reviewed every claim on this paper, please remember to click
        <strong>Submit this paper</strong> at the top so your selections are recorded for the
        cycle. You can return to this page any time before the cycle is frozen.
    </p>
</div>

<script>
const TOKEN = document.body.dataset.token;
const PMID  = document.body.dataset.pmid;

function markSelected(card) {
    const el = card.querySelector('.selected-tag');
    if (el) el.classList.add('show');
}

function postVote(uid, fields) {
    const fd = new FormData();
    fd.append('t', TOKEN);
    fd.append('association_uid', uid);
    fd.append('pmid', PMID);
    Object.entries(fields).forEach(([k, v]) => { if (v !== null) fd.append(k, v); });
    return fetch('api/vote.php', { method: 'POST', body: fd });
}

document.querySelectorAll('.card').forEach(card => {
    const uid = card.dataset.uid;

    card.querySelectorAll('.ev-btn').forEach(btn => {
        btn.addEventListener('click', async () => {
            card.querySelectorAll('.ev-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            await postVote(uid, { evidence_vote: btn.dataset.vote });
            markSelected(card);
        });
    });

    card.querySelectorAll('.tx-btn').forEach(btn => {
        btn.addEventListener('click', async () => {
            card.querySelectorAll('.tx-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            await postVote(uid, { text_vote: btn.dataset.vote });
            markSelected(card);
        });
    });

    const cmt = card.querySelector('.cmt-input');
    if (cmt) {
        let timer = null;
        cmt.addEventListener('input', () => {
            clearTimeout(timer);
            timer = setTimeout(async () => {
                await postVote(uid, { comment: cmt.value });
                markSelected(card);
            }, 600);
        });
    }
});

// Persist Guidelines collapse state across paper navigations.
const guidelinesDetails = document.getElementById('guidelines-details');
if (guidelinesDetails) {
    const stored = localStorage.getItem('mca-review-guidelines-open');
    if (stored !== null) guidelinesDetails.open = (stored === '1');
    guidelinesDetails.addEventListener('toggle', () => {
        localStorage.setItem('mca-review-guidelines-open',
                             guidelinesDetails.open ? '1' : '0');
    });
}

const ctxInput = document.getElementById('ctx-comment-input');
if (ctxInput) {
    let timer = null;
    ctxInput.addEventListener('input', () => {
        clearTimeout(timer);
        timer = setTimeout(() => {
            const fd = new FormData();
            fd.append('t', TOKEN);
            fd.append('pmid', PMID);
            fd.append('comment', ctxInput.value);
            fetch('api/context.php', { method: 'POST', body: fd });
        }, 600);
    });
}

const submitBtn = document.getElementById('submit-btn');
if (submitBtn) {
    submitBtn.addEventListener('click', async () => {
        const fd = new FormData();
        fd.append('t', TOKEN);
        fd.append('pmid', PMID);
        const r = await fetch('api/submit.php', { method: 'POST', body: fd });
        if (r.ok) {
            submitBtn.classList.add('done');
            submitBtn.disabled = true;
            let secs = 3;
            submitBtn.textContent = `✓ Submitted — back to paper list in ${secs}...`;
            const tick = setInterval(() => {
                secs--;
                if (secs <= 0) {
                    clearInterval(tick);
                    location.href = 'review.php?t=' + encodeURIComponent(TOKEN);
                } else {
                    submitBtn.textContent = `✓ Submitted — back to paper list in ${secs}...`;
                }
            }, 1000);
        } else {
            submitBtn.textContent = 'Submit failed — try again';
        }
    });
}
</script>
</body>
</html>
