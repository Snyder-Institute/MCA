<?php
/**
 * review_rounds.php — single source of truth for the round → PMID mapping.
 *
 * Cycle re-minted 2026-05-06. MCA has 25 curated papers; 24 carry
 * reviewable claims. The 25th (PMID 31548871) has zero clinical
 * associations and is omitted entirely from this filter.
 *
 *   Round 1 (11 papers) — anchored by E3/E2 claims (highest-priority validation)
 *   Round 2 (9 papers)  — E1-dominant papers (sent after round 1 closes)
 *   Skip   (4 papers)   — all-UNCERTAIN claims (excluded from SQL anyway)
 *
 * Both review.php (paper list) and review_paper.php (per-paper voting + access
 * gate) require this file so the arrays only live in one place.
 */

declare(strict_types=1);

$round_1_pmids = [41814006, 38584858, 29097494, 33542131, 36894652,
                  29302014, 29097493, 34941392, 33432149, 29590047,
                  29546356];
$round_2_pmids = [39456922, 35831502, 40544256, 32758418,
                  33303685, 24503131, 33766858, 25385792, 29414937];
$skip_pmids    = [32129694, 38786164, 41641127, 41039149];

/**
 * Return the PMID list a given token's round should see.
 * Defaults to round 1 if the round value is unknown.
 */
function active_round_pmids(int $token_round, array $r1, array $r2): array
{
    return $token_round === 2 ? $r2 : $r1;
}

/**
 * Return the evidence-level set for a given round. Round 1 reviews the
 * high-confidence claims (E3/E2). Round 2 reviews E1 claims on the
 * E1-dominant papers. UNCERTAIN claims are excluded from MCA SQL by
 * xml2sql.py and are not reviewed.
 */
function active_evidence_levels(int $token_round): array
{
    return $token_round === 2 ? ['E1'] : ['E3', 'E2'];
}

/**
 * Build a SQL-safe quoted CSV from an evidence-level list, suitable for
 * inlining in `IN (...)`. Values come from active_evidence_levels(), which
 * is fully controlled and never user input — but we still validate
 * against the known enum to be safe.
 */
function evidence_levels_sql(array $levels): string
{
    $valid = ['E1', 'E2', 'E3', 'UNCERTAIN'];
    $clean = array_filter($levels, fn($l) => in_array($l, $valid, true));
    return "'" . implode("','", $clean) . "'";
}
