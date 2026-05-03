<?php
/**
 * review_auth.php — token validator for review pages.
 *
 * Reads ?t=<TOKEN> from the request and validates it against
 * MCA_review.review_token. On any failure (missing, malformed, or
 * revoked token) issues a 302 redirect to https://mca.thebiohub.ca/
 * — friendlier than a bare "Forbidden". On success sets
 * $review_token (string) and leaves $pdo_review available for the
 * caller.
 *
 * Every review-system PHP file must require_once this helper as its
 * first DB-touching action.
 */

declare(strict_types=1);

header('X-Robots-Tag: noindex, nofollow', true);

require_once __DIR__ . '/db_review_connect.php';

/**
 * Redirect to the public MCA homepage when the token is missing, malformed,
 * or revoked. Friendlier than a bare "Forbidden" — the user can still find
 * something useful at mca.thebiohub.ca.
 */
function _review_auth_redirect(): void
{
    header('Location: https://mca.thebiohub.ca/', true, 302);
    exit;
}

$review_token = isset($_GET['t']) ? (string) $_GET['t'] : (string) ($_POST['t'] ?? '');
if (!preg_match('/^[a-f0-9]{64}$/', $review_token)) {
    _review_auth_redirect();
}

$stmt = $pdo_review->prepare(
    'SELECT 1 FROM review_token WHERE token = :t AND revoked_at IS NULL LIMIT 1'
);
$stmt->execute(['t' => $review_token]);
if (!$stmt->fetchColumn()) {
    _review_auth_redirect();
}
