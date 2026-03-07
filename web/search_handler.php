<?php
require_once 'db_connect.php';

$q = isset($_GET['q']) ? trim($_GET['q']) : '';
$results = [];

if ($q !== '') {
    $term = '%' . $q . '%';
    try {
        $stmt = $pdo->prepare("
            SELECT DISTINCT p.passport_id, p.preferred_name
            FROM mca_taxon_passport p
            LEFT JOIN mca_taxon_synonym s ON p.passport_id = s.passport_id
            WHERE p.preferred_name LIKE ? 
               OR p.passport_id LIKE ? 
               OR s.synonym LIKE ?
            ORDER BY p.preferred_name ASC
            LIMIT 10
        ");
        $stmt->execute([$term, $term, $term]);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        // Fail silently for live search
    }
}

header('Content-Type: application/json');
echo json_encode($results);