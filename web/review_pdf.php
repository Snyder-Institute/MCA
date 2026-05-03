<?php
/**
 * review_pdf.php — token-gated PDF stream.
 *
 * GET: ?t=<TOKEN>&pmid=<PMID>
 *
 * Reads review_data/pdfs/<PMID>.pdf and streams it inline. Never the
 * direct file URL — copyright + access control + audit trail.
 */

declare(strict_types=1);
require_once __DIR__ . '/review_auth.php';

$pmid = isset($_GET['pmid']) ? (int) $_GET['pmid'] : 0;
if ($pmid <= 0) { http_response_code(400); exit('Bad request'); }

// Confirm this token has the paper in its queue
$stmt = $pdo_review->prepare(
    'SELECT 1 FROM review_paper WHERE token = :t AND pmid = :p LIMIT 1'
);
$stmt->execute(['t' => $review_token, 'p' => $pmid]);
if (!$stmt->fetchColumn()) { http_response_code(404); exit('Not found'); }

// review_data/ is mounted next to the docroot in docker; on production it
// lives under /var/www/review_data per the same convention.
$pdf_dirs = [
    __DIR__ . '/../review_data/pdfs',
    '/var/www/review_data/pdfs',
];
$pdf_path = null;
foreach ($pdf_dirs as $d) {
    $candidate = $d . '/' . $pmid . '.pdf';
    if (is_file($candidate)) { $pdf_path = $candidate; break; }
}
if ($pdf_path === null) { http_response_code(404); exit('PDF not available'); }

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="PMID' . $pmid . '.pdf"');
header('Content-Length: ' . filesize($pdf_path));
header('X-Robots-Tag: noindex, nofollow', true);
readfile($pdf_path);
