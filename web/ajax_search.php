<?php
header('Content-Type: application/json');
require_once 'db_connect.php';

$query = $_GET['q'] ?? '';

if (strlen($query) < 2) {
    echo json_encode([]);
    exit;
}

try {
    $stmt = $pdo->prepare("
        SELECT DISTINCT p.passport_id, p.preferred_name 
        FROM mca_taxon_passport p
        LEFT JOIN mca_taxon_synonym s ON p.passport_id = s.passport_id
        WHERE p.preferred_name LIKE ? 
           OR s.synonym LIKE ? 
           OR p.passport_id LIKE ?
        LIMIT 10
    ");
    
    $searchTerm = "%$query%";
    $stmt->execute([$searchTerm, $searchTerm, $searchTerm]);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($results);

} catch (\PDOException $e) {
    echo json_encode([]);
}