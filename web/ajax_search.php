<?php
header('Content-Type: application/json');
require_once 'db_connect.php';

$query = $_GET['q'] ?? '';

if (strlen($query) < 2) {
    echo json_encode([]);
    exit;
}

try {
    $term = "%$query%";

    $stmt = $pdo->prepare("
        SELECT DISTINCT p.passport_id, p.preferred_name, 'name' AS match_type, NULL AS match_detail
        FROM passport p
        WHERE p.preferred_name LIKE ?
        UNION
        SELECT DISTINCT p.passport_id, p.preferred_name, 'synonym' AS match_type, NULL AS match_detail
        FROM passport p
        INNER JOIN taxon_tag s ON s.passport_id = p.id AND s.category = 'synonym'
        WHERE s.value LIKE ?
          AND p.preferred_name NOT LIKE ?
        UNION
        SELECT DISTINCT p.passport_id, p.preferred_name, 'id' AS match_type, NULL AS match_detail
        FROM passport p
        WHERE p.passport_id LIKE ?
          AND p.preferred_name NOT LIKE ?
        UNION
        SELECT DISTINCT p.passport_id, p.preferred_name, 'tag' AS match_type,
               CONCAT(t.category, ': ', t.value) AS match_detail
        FROM passport p
        INNER JOIN taxon_tag t ON t.passport_id = p.id
            AND t.category IN ('primary_niche','bloom_trigger','risk_context','typical_specimen')
            AND t.value LIKE ?
        WHERE p.preferred_name NOT LIKE ?
          AND p.passport_id NOT LIKE ?
        ORDER BY preferred_name ASC
        LIMIT 10
    ");

    $stmt->execute([$term, $term, $term, $term, $term, $term, $term, $term]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $seen = [];
    $output = [];
    foreach ($rows as $row) {
        $pid = $row['passport_id'];
        if (!isset($seen[$pid])) {
            $seen[$pid] = true;
            $item = [
                'passport_id'   => $row['passport_id'],
                'preferred_name' => $row['preferred_name'],
                'match_type'    => $row['match_type'],
            ];
            if ($row['match_type'] === 'tag' && !empty($row['match_detail'])) {
                $item['match_detail'] = $row['match_detail'];
            }
            $output[] = $item;
        }
    }

    echo json_encode($output);

} catch (\PDOException $e) {
    echo json_encode([]);
}
