<?php
/**
 * api/submit.php — flag a paper as 'submitted' for a given token.
 *
 * POST: t, pmid
 *
 * Soft signal. Page stays editable until the curator runs freeze_reviews.py.
 * Returns 204 on success.
 */

declare(strict_types=1);

require_once __DIR__ . '/../review_auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Method not allowed');
}

$pmid = (int) ($_POST['pmid'] ?? 0);
if ($pmid <= 0) {
    http_response_code(400);
    exit('Bad request');
}

$stmt = $pdo_review->prepare(
    "UPDATE review_paper
     SET status = 'submitted', submitted_at = NOW()
     WHERE token = :t AND pmid = :p AND status <> 'frozen'"
);
$stmt->execute(['t' => $review_token, 'p' => $pmid]);

if ($stmt->rowCount() === 0) {
    http_response_code(404);
    exit('Not found or frozen');
}

http_response_code(204);
