<?php
/**
 * api/vote.php — auto-save endpoint for evidence/text votes and comments.
 *
 * POST: t, association_uid, pmid, [evidence_vote], [text_vote], [comment]
 *
 * Idempotent UPSERT into review_vote keyed by (token, association_uid).
 * Each call updates only the columns the client sent; the others are
 * preserved via COALESCE. Comment is special-cased: an empty string
 * clears the stored value, so the curator can erase a comment.
 *
 * Returns 204 on success, 403 if the (token, paper) review is frozen,
 * 404 if the paper isn't in this token's queue.
 */

declare(strict_types=1);

require_once __DIR__ . '/../review_auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Method not allowed');
}

$uid = (string) ($_POST['association_uid'] ?? '');
$pmid = (int) ($_POST['pmid'] ?? 0);
if ($uid === '' || $pmid <= 0) {
    http_response_code(400);
    exit('Bad request');
}

$ev = isset($_POST['evidence_vote']) ? (string) $_POST['evidence_vote'] : null;
$tx = isset($_POST['text_vote'])     ? (string) $_POST['text_vote']     : null;
$cm = isset($_POST['comment'])       ? (string) $_POST['comment']       : null;

$valid_ev = ['E1', 'E2', 'E3', 'UNDETERMINED'];
$valid_tx = ['accurate', 'overstated', 'understated', 'unsure'];
if ($ev !== null && !in_array($ev, $valid_ev, true)) {
    http_response_code(400);
    exit('Bad evidence_vote');
}
if ($tx !== null && !in_array($tx, $valid_tx, true)) {
    http_response_code(400);
    exit('Bad text_vote');
}
if ($cm !== null) {
    // Trim whitespace; treat empty string as NULL so DB stays clean.
    $cm = trim($cm);
    if ($cm === '') $cm = null;
    if ($cm !== null && strlen($cm) > 5000) $cm = substr($cm, 0, 5000);
}

// Refuse writes when the (token, paper) review is frozen
$stmt = $pdo_review->prepare(
    'SELECT status FROM review_paper WHERE token = :t AND pmid = :p LIMIT 1'
);
$stmt->execute(['t' => $review_token, 'p' => $pmid]);
$rp = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$rp) { http_response_code(404); exit('Paper not in queue'); }
if ($rp['status'] === 'frozen') { http_response_code(403); exit('Frozen'); }

// UPSERT: only overwrite the columns the client sent. Use COALESCE on the
// others so previous state is preserved. Comments are special-cased:
// the client always sends "comment" (possibly empty); we want to clear the
// stored value when the client sends empty, but otherwise leave it alone.
$comment_was_sent = isset($_POST['comment']);
$sql = "INSERT INTO review_vote
            (token, association_uid, pmid, evidence_vote, text_vote, comment, updated_at)
        VALUES (:t, :u, :p, :ev, :tx, :cm, NOW())
        ON DUPLICATE KEY UPDATE
            evidence_vote = COALESCE(VALUES(evidence_vote), evidence_vote),
            text_vote     = COALESCE(VALUES(text_vote),     text_vote),
            comment       = " . ($comment_was_sent ? "VALUES(comment)" : "comment") . ",
            updated_at    = NOW()";
$stmt = $pdo_review->prepare($sql);
$stmt->execute([
    't'  => $review_token,
    'u'  => $uid,
    'p'  => $pmid,
    'ev' => $ev,
    'tx' => $tx,
    'cm' => $cm,
]);

// Bump review_paper.status to 'in_progress' if it was anywhere else
$pdo_review->prepare(
    "UPDATE review_paper SET status = 'in_progress'
     WHERE token = :t AND pmid = :p AND status = 'submitted'"
)->execute(['t' => $review_token, 'p' => $pmid]);

http_response_code(204);
