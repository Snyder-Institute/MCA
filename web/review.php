<?php
/**
 * review.php — reviewer landing page; lists all papers in the cycle.
 */

declare(strict_types=1);
require_once __DIR__ . '/review_auth.php';
require_once __DIR__ . '/review_rounds.php';

// Each token is bound to a review round in MCA_review.review_token.round
// (default 1, schema 002). review.php picks the visible paper list from
// the token's round so round-1 and round-2 reviewers can run in parallel
// without a global flag flip.
$stmt = $pdo_review->prepare(
    "SELECT round FROM review_token WHERE token = :t LIMIT 1"
);
$stmt->execute(['t' => $review_token]);
$token_round = (int) ($stmt->fetchColumn() ?: 1);

$active_round_pmids = active_round_pmids($token_round, $round_1_pmids, $round_2_pmids);
$pmid_csv = implode(',', array_map('intval', $active_round_pmids));
$levels_csv = evidence_levels_sql(active_evidence_levels($token_round));

$stmt = $pdo_review->prepare(
    "SELECT
         rp.pmid,
         rp.status,
         ps.title, ps.journal, ps.year, ps.keywords,
         COUNT(a.association_uid) AS n_associations,
         SUM(CASE WHEN a.evidence_level = 'E3' THEN 1 ELSE 0 END) AS n_e3,
         SUM(CASE WHEN a.evidence_level = 'E2' THEN 1 ELSE 0 END) AS n_e2,
         SUM(CASE WHEN a.evidence_level = 'E1' THEN 1 ELSE 0 END) AS n_e1,
         (
             SELECT COUNT(*) FROM review_vote v
             JOIN association_snapshot a2 ON a2.association_uid = v.association_uid
             WHERE v.token = rp.token
               AND a2.pmid = rp.pmid
               AND a2.evidence_level IN ($levels_csv)
         ) AS n_voted
     FROM review_paper rp
     JOIN paper_snapshot ps ON ps.pmid = rp.pmid
     -- INNER JOIN drops papers with no claims at the active evidence levels
     -- (round 1 = E3+E2; round 2 = E1; both filter out UNCERTAIN entirely).
     JOIN association_snapshot a ON a.pmid = rp.pmid
                                AND a.evidence_level IN ($levels_csv)
     WHERE rp.token = :t
       AND rp.pmid IN ($pmid_csv)
     GROUP BY rp.pmid, rp.token, rp.status, ps.title, ps.journal, ps.year, ps.keywords
     ORDER BY FIELD(rp.pmid, $pmid_csv)"
);
$stmt->execute(['t' => $review_token]);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

/**
 * Compute the displayed status pill from the row's stored status plus the
 * count of recorded votes.
 */
function pill_for(string $status, int $n_voted): array
{
    if ($status === 'frozen')    return ['Read-only',   '#aaa'];
    if ($status === 'submitted') return ['Submitted',   '#0a7'];
    if ($n_voted > 0)            return ['In progress', '#fbbf24'];
    return ['Not started', '#888'];
}

// True when the entire cycle for this reviewer is frozen (every paper).
$cycle_frozen = !empty($rows)
    && array_reduce($rows, fn($acc, $r) => $acc && $r['status'] === 'frozen', true);

function pill(string $status, int $n_voted): string
{
    [$label, $color] = pill_for($status, $n_voted);
    return sprintf(
        '<span style="display:inline-block;padding:2px 9px;border-radius:10px;'
        . 'font-size:11px;background:%s;color:#fff;">%s</span>',
        htmlspecialchars($color),
        htmlspecialchars($label)
    );
}

?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="robots" content="noindex, nofollow">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MCA Review — paper list</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
         margin: 0; padding: 24px; max-width: 1100px; margin: 0 auto; color: #222; }
  h1 { font-size: 22px; margin: 0 0 4px; }
  .lede { color: #666; font-size: 14px; margin-bottom: 24px; }
  table { border-collapse: collapse; width: 100%; table-layout: fixed; }
  th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid #eee;
           font-size: 14px; vertical-align: top; }
  th { background: #fafafa; font-weight: 600; color: #555; font-size: 12px;
       text-transform: uppercase; letter-spacing: 0.4px; }
  tr:hover td { background: #fcfcfc; }
  a { color: #404f7c; text-decoration: none; }
  a:hover { text-decoration: underline; }
  .col-paper    { width: auto; }
  .col-progress { width: 90px;  text-align: center; }
  .col-status   { width: 130px; text-align: center; }
  td.col-progress, td.col-status { text-align: center; }
  .paper-title  { font-weight: 500; line-height: 1.4; }
  .paper-meta   { color: #888; font-size: 12.5px; margin-top: 2px; }
  .paper-meta em { font-style: italic; }
  .paper-keywords { color: #888; font-size: 12px; margin-top: 4px;
                    font-style: italic; line-height: 1.4; }
  .paper-keywords .kw-label { font-style: normal; font-weight: 600; color: #666; }
  .closed-banner { background: #fef3c7; border-left: 4px solid #fbbf24;
                   padding: 14px 18px; margin: 16px 0 24px; border-radius: 6px;
                   font-size: 14px; line-height: 1.55; color: #555; }
  .closed-banner strong { color: #92400e; display: block; margin-bottom: 4px;
                          font-size: 15px; }
</style>
</head>
<body>
<h1>MCA Expert Review</h1>

<?php if ($cycle_frozen): ?>
<div class="closed-banner">
    <strong>Voting is now closed.</strong>
    Your selections have been preserved on every paper below — thank you for the time and
    expertise you contributed. We are deeply grateful. The papers remain visible in
    read-only mode so you can revisit anything you reviewed.
</div>
<?php endif ?>

<p class="lede">
    Thank you for sharing your expertise with us — your time and judgment genuinely shape how
    reliable the <a href="https://mca.thebiohub.ca/" target="_blank" rel="noopener">Microbial Clinical Atlas</a>
    becomes for everyone who depends on it. Please review
    each paper at your own pace and click <strong>Submit this paper</strong> when you have finished
    each one. You can return and edit your selections any time until the cycle is frozen.
</p>

<table>
<thead>
<tr>
    <th class="col-paper">Paper</th>
    <th class="col-progress">Progress</th>
    <th class="col-status">Status</th>
</tr>
</thead>
<tbody>
<?php foreach ($rows as $r):
    $url = sprintf('review_paper.php?t=%s&pmid=%d',
                   urlencode($review_token), $r['pmid']);
    $progress = sprintf('%d / %d', $r['n_voted'], $r['n_associations']);
?>
<tr>
    <td class="col-paper">
        <div class="paper-title">
            <a href="<?= htmlspecialchars($url) ?>"><?= htmlspecialchars($r['title']) ?></a>
        </div>
        <div class="paper-meta">
            <?php if ($r['journal']): ?><em><?= htmlspecialchars($r['journal']) ?></em><?php endif ?>
            <?php if ($r['year']): ?> (<?= htmlspecialchars((string) $r['year']) ?>)<?php endif ?>
        </div>
        <?php if (!empty($r['keywords'])): ?>
        <div class="paper-keywords"><span class="kw-label">Keywords:</span> <?= htmlspecialchars($r['keywords']) ?></div>
        <?php endif ?>
    </td>
    <td class="col-progress"><?= htmlspecialchars($progress) ?></td>
    <td class="col-status"><?= pill((string) $r['status'], (int) $r['n_voted']) ?></td>
</tr>
<?php endforeach ?>
</tbody>
</table>

</body>
</html>
