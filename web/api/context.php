<?php
/**
 * api/context.php — auto-save endpoint for the per-paper context comment.
 *
 * POST: t, pmid, comment
 *
 * Stores into review_paper.context_comment. Refuses writes when the
 * (token, paper) review is frozen.
 */

declare(strict_types=1);

require_once __DIR__ . '/../review_auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Method not allowed');
}

$pmid = (int) ($_POST['pmid'] ?? 0);
if ($pmid <= 0) { http_response_code(400); exit('Bad request'); }

$cm = trim((string) ($_POST['comment'] ?? ''));
if ($cm === '') $cm = null;
if ($cm !== null && strlen($cm) > 5000) $cm = substr($cm, 0, 5000);

$stmt = $pdo_review->prepare(
    "UPDATE review_paper
     SET context_comment = :c
     WHERE token = :t AND pmid = :p AND status <> 'frozen'"
);
$stmt->execute(['c' => $cm, 't' => $review_token, 'p' => $pmid]);

if ($stmt->rowCount() === 0) {
    // The row may exist with status='frozen' or not exist at all. Distinguish.
    $check = $pdo_review->prepare(
        'SELECT status FROM review_paper WHERE token = :t AND pmid = :p LIMIT 1'
    );
    $check->execute(['t' => $review_token, 'p' => $pmid]);
    $r = $check->fetch(PDO::FETCH_ASSOC);
    http_response_code($r === false ? 404 : 403);
    exit;
}

http_response_code(204);
