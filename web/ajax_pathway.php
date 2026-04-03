<?php
/**
 * ajax_pathway.php — KEGG pathway search AJAX endpoint.
 *
 * GET parameters:
 *   mode   : autocomplete | pathway | taxon | disease | browse
 *   q      : search query (string)
 *   id     : KEGG ID or passport_id (for direct lookups)
 *   limit  : max results for autocomplete (default 10)
 */

header('Content-Type: application/json; charset=utf-8');

// ── Load index ────────────────────────────────────────────────────────────────

$index_path = __DIR__ . '/data/kegg_brite_index.json';
if (!file_exists($index_path)) {
    http_response_code(503);
    echo json_encode(['error' => 'Pathway index not found. Run database/build_brite_index.py first.']);
    exit;
}

$idx = json_decode(file_get_contents($index_path), true);
if ($idx === null) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to parse pathway index.']);
    exit;
}

// ── DB connection (for passport details) ─────────────────────────────────────

require_once __DIR__ . '/db_connect.php';

function get_passport_details(PDO $pdo, array $passport_ids): array {
    if (empty($passport_ids)) return [];
    $placeholders = implode(',', array_fill(0, count($passport_ids), '?'));
    $sql = "SELECT p.passport_id, p.preferred_name, p.taxon_rank, p.domain, p.is_pathobiont,
                   GROUP_CONCAT(DISTINCT tt.value ORDER BY tt.value SEPARATOR '||') AS roles
            FROM passport p
            LEFT JOIN taxon_tag tt ON tt.passport_id = p.id AND tt.category = 'role'
            WHERE p.passport_id IN ($placeholders)
            GROUP BY p.id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(array_values($passport_ids));
    $rows = [];
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $row['roles'] = $row['roles'] ? explode('||', $row['roles']) : [];
        $rows[$row['passport_id']] = $row;
    }
    return $rows;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function icontains(string $haystack, string $needle): bool {
    return stripos($haystack, $needle) !== false;
}

function pathway_entry(array $idx, string $pid): array {
    $p = $idx['pathways'][$pid] ?? ['id' => $pid, 'name' => $pid, 'category' => '', 'subcategory' => ''];
    $p['taxon_count'] = count($idx['pathway_to_passports'][$pid] ?? []);
    return $p;
}

$mode  = $_GET['mode']  ?? 'autocomplete';
$q     = trim($_GET['q']     ?? '');
$id    = trim($_GET['id']    ?? '');
$limit = max(1, min(50, (int)($_GET['limit'] ?? 10)));

// ── Mode: autocomplete ────────────────────────────────────────────────────────

if ($mode === 'autocomplete') {
    $results = ['pathways' => [], 'taxa' => [], 'diseases' => []];
    if (strlen($q) < 2) { echo json_encode($results); exit; }

    // Pathways — only those linked to at least one MCA passport
    foreach ($idx['pathway_to_passports'] as $pid => $passports) {
        if (count($results['pathways']) >= $limit) break;
        $p = $idx['pathways'][$pid] ?? null;
        if (!$p) continue;
        if (icontains($p['name'], $q) || icontains($pid, $q)) {
            $results['pathways'][] = [
                'id'           => $pid,
                'name'         => $p['name'],
                'category'     => $p['category'],
                'taxon_count'  => count($passports),
            ];
        }
    }

    // Taxa
    foreach ($idx['passport_names'] as $pid => $name) {
        if (count($results['taxa']) >= $limit) break;
        if (icontains($name, $pid) || icontains($name, $q)) {
            $results['taxa'][] = [
                'passport_id' => $pid,
                'name'        => $name,
                'has_pathways'=> isset($idx['passport_to_pathways'][$pid]),
            ];
        }
    }

    // Diseases (only MCA-relevant ones in the index)
    foreach ($idx['disease_names'] as $hid => $dname) {
        if (count($results['diseases']) >= $limit) break;
        if (icontains($dname, $q) || icontains($hid, $q)) {
            $results['diseases'][] = [
                'id'   => $hid,
                'name' => $dname,
            ];
        }
    }

    echo json_encode($results);
    exit;
}

// ── Mode: pathway (Q3 — pathway → taxa) ──────────────────────────────────────

if ($mode === 'pathway') {
    if (!$id) { echo json_encode(['error' => 'Missing id']); exit; }

    $pathway_info = pathway_entry($idx, $id);
    $passport_ids = $idx['pathway_to_passports'][$id] ?? [];

    $details = get_passport_details($pdo, $passport_ids);

    $taxa = [];
    foreach ($passport_ids as $pid) {
        $kegg    = $idx['passport_kegg'][$pid]   ?? [];
        $detail  = $details[$pid]                 ?? [];

        // Which diseases from this passport are in this pathway?
        $via_diseases = [];
        foreach (($kegg['diseases'] ?? []) as $hid => $hlabel) {
            $hpaths = array_merge(
                $idx['disease_to_pathways'][$hid] ?? [],
                $idx['disease_to_nt'][$hid]        ?? []
            );
            if (in_array($id, $hpaths)) {
                $via_diseases[] = ['id' => $hid, 'label' => $hlabel ?: ($idx['disease_names'][$hid] ?? $hid)];
            }
        }

        // Which compounds from this passport are in this pathway?
        $via_compounds = [];
        foreach (($kegg['compounds'] ?? []) as $cid => $cname) {
            $cpaths = $idx['compound_to_pathways'][$cid] ?? [];
            if (in_array($id, $cpaths)) {
                $via_compounds[] = ['id' => $cid, 'name' => $cname ?: ($idx['compound_names'][$cid] ?? $cid)];
            }
        }

        $taxa[] = [
            'passport_id'   => $pid,
            'name'          => $detail['preferred_name'] ?? ($idx['passport_names'][$pid] ?? $pid),
            'taxon_rank'    => $detail['taxon_rank']     ?? '',
            'is_pathobiont' => $detail['is_pathobiont']  ?? 'unknown',
            'roles'         => $detail['roles']          ?? [],
            'via_diseases'  => $via_diseases,
            'via_compounds' => $via_compounds,
        ];
    }

    // Related diseases in this pathway (all, not just MCA-linked)
    $related_diseases = [];
    foreach (($idx['pathway_to_diseases'][$id] ?? []) as $hid) {
        $related_diseases[] = ['id' => $hid, 'name' => $idx['disease_names'][$hid] ?? $hid];
    }
    foreach (($idx['nt_to_diseases'][$id] ?? []) as $hid) {
        $related_diseases[] = ['id' => $hid, 'name' => $idx['disease_names'][$hid] ?? $hid];
    }
    // Deduplicate
    $seen = [];
    $related_diseases = array_values(array_filter($related_diseases, function($d) use (&$seen) {
        if (isset($seen[$d['id']])) return false;
        $seen[$d['id']] = true;
        return true;
    }));

    echo json_encode([
        'pathway'          => $pathway_info,
        'taxa'             => $taxa,
        'related_diseases' => $related_diseases,
    ]);
    exit;
}

// ── Mode: taxon (Q1 + Q6 — taxon → pathways + co-occurring taxa) ─────────────

if ($mode === 'taxon') {
    if (!$id) { echo json_encode(['error' => 'Missing id']); exit; }

    $kegg   = $idx['passport_kegg'][$id]          ?? [];
    $paths  = $idx['passport_to_pathways'][$id]   ?? [];
    $cooc   = $idx['passport_cooccurrence'][$id]  ?? [];

    // Pathways grouped by source
    $via_diseases  = [];
    $via_compounds = [];

    foreach ($paths as $pid) {
        $pinfo = pathway_entry($idx, $pid);

        // Which diseases link this taxon to this pathway?
        $linking_diseases = [];
        foreach (($kegg['diseases'] ?? []) as $hid => $hlabel) {
            $hpaths = array_merge(
                $idx['disease_to_pathways'][$hid] ?? [],
                $idx['disease_to_nt'][$hid]        ?? []
            );
            if (in_array($pid, $hpaths)) {
                $linking_diseases[] = ['id' => $hid, 'label' => $hlabel ?: ($idx['disease_names'][$hid] ?? $hid)];
            }
        }

        // Which compounds link this taxon to this pathway?
        $linking_compounds = [];
        foreach (($kegg['compounds'] ?? []) as $cid => $cname) {
            $cpaths = $idx['compound_to_pathways'][$cid] ?? [];
            if (in_array($pid, $cpaths)) {
                $linking_compounds[] = ['id' => $cid, 'name' => $cname ?: ($idx['compound_names'][$cid] ?? $cid)];
            }
        }

        $entry = array_merge($pinfo, ['linking_diseases' => $linking_diseases, 'linking_compounds' => $linking_compounds]);

        if ($linking_diseases)  $via_diseases[]  = $entry;
        if ($linking_compounds) $via_compounds[] = $entry;
    }

    // Drug target classes
    $drug_classes = [];
    foreach (($kegg['drugs'] ?? []) as $did => $dname) {
        $dc = $idx['drug_class'][$did] ?? null;
        if ($dc) {
            $drug_classes[] = array_merge(['id' => $did, 'name' => $dname ?: ($idx['drug_names'][$did] ?? $did)], $dc);
        }
    }

    // Co-occurring taxa (Q6) — sort by shared pathway count
    arsort($cooc);
    $cooc_ids = array_keys(array_slice($cooc, 0, 20, true));
    $cooc_details = get_passport_details($pdo, $cooc_ids);
    $cooccurring = [];
    foreach ($cooc_ids as $cpid) {
        $cooccurring[] = [
            'passport_id'    => $cpid,
            'name'           => $cooc_details[$cpid]['preferred_name'] ?? ($idx['passport_names'][$cpid] ?? $cpid),
            'is_pathobiont'  => $cooc_details[$cpid]['is_pathobiont']  ?? 'unknown',
            'shared_pathways'=> $cooc[$cpid],
        ];
    }

    echo json_encode([
        'passport_id'  => $id,
        'name'         => $idx['passport_names'][$id] ?? $id,
        'pathways'     => [
            'via_diseases'  => $via_diseases,
            'via_compounds' => $via_compounds,
        ],
        'drug_classes' => $drug_classes,
        'cooccurring'  => $cooccurring,
        'total_pathways' => count($paths),
    ]);
    exit;
}

// ── Mode: disease (Q4 — disease → passports + pathways) ──────────────────────

if ($mode === 'disease') {
    if (!$id) { echo json_encode(['error' => 'Missing id']); exit; }

    $dname = $idx['disease_names'][$id] ?? $id;

    // Pathways for this disease
    $paths = array_unique(array_merge(
        $idx['disease_to_pathways'][$id] ?? [],
        $idx['disease_to_nt'][$id]        ?? []
    ));
    $pathway_list = array_map(fn($pid) => pathway_entry($idx, $pid), $paths);

    // Passports that reference this disease
    $passport_ids = [];
    foreach ($idx['passport_kegg'] as $pid => $kegg) {
        if (isset($kegg['diseases'][$id])) {
            $passport_ids[] = $pid;
        }
    }
    $details = get_passport_details($pdo, $passport_ids);

    $taxa = [];
    foreach ($passport_ids as $pid) {
        $d = $details[$pid] ?? [];
        $taxa[] = [
            'passport_id'   => $pid,
            'name'          => $d['preferred_name'] ?? ($idx['passport_names'][$pid] ?? $pid),
            'taxon_rank'    => $d['taxon_rank']     ?? '',
            'is_pathobiont' => $d['is_pathobiont']  ?? 'unknown',
            'roles'         => $d['roles']          ?? [],
        ];
    }

    // Infectious disease classification
    $inf = $idx['inf_class'][$id] ?? null;

    echo json_encode([
        'disease'  => ['id' => $id, 'name' => $dname],
        'pathways' => $pathway_list,
        'taxa'     => $taxa,
        'inf_class'=> $inf,
    ]);
    exit;
}

// ── Mode: browse (Q5 — all pathways with taxon counts) ───────────────────────

if ($mode === 'browse') {
    $rows = [];
    foreach ($idx['pathway_to_passports'] as $pid => $passports) {
        $p = $idx['pathways'][$pid] ?? null;
        if (!$p) continue;
        $rows[] = [
            'id'          => $pid,
            'name'        => $p['name'],
            'category'    => $p['category'],
            'subcategory' => $p['subcategory'] ?? '',
            'taxon_count' => count($passports),
        ];
    }
    // Sort by category asc, then pathway name asc
    usort($rows, fn($a, $b) => strcmp($a['category'], $b['category']) ?: strcmp($a['name'], $b['name']));
    echo json_encode(['pathways' => $rows]);
    exit;
}

http_response_code(400);
echo json_encode(['error' => "Unknown mode: $mode"]);
