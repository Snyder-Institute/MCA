<?php
ini_set('memory_limit', '512M');
set_time_limit(0); 

require_once 'db_connect.php';

try {
    $version_stmt = $pdo->query("SELECT version FROM mca_taxon_passport LIMIT 1");
    $db_version = $version_stmt->fetchColumn() ?: 'v0.1';
    
    $filename = "MCA_DB_" . htmlspecialchars($db_version) . ".xml";
    $full_path = __DIR__ . "/data/" . $filename;

    if (!is_dir(__DIR__ . "/data")) {
        mkdir(__DIR__ . "/data", 0755, true);
    }

    $xml = new XMLWriter();
    if (!$xml->openURI($full_path)) {
        die("Error: Could not open $full_path for writing. Check permissions.\n");
    }

    $xml->setIndent(true);
    $xml->startDocument('1.0', 'UTF-8');
    $xml->startElement('MicrobialClinicalAtlas');

    $stmt = $pdo->query("SELECT * FROM mca_taxon_passport");
    
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $xml->startElement('TaxonPassport');
        foreach ($row as $key => $value) {
            $xml->writeElement($key, htmlspecialchars($value ?? ''));
        }
        $xml->endElement(); 
        
        if ($stmt->rowCount() % 1000 == 0) {
            $xml->flush();
        }
    }

    $xml->endElement(); 
    $xml->endDocument();
    $xml->flush();

    echo "Export successful: " . $full_path . "\n";

} catch (\PDOException $e) {
    error_log($e->getMessage());
    die("Export failed: " . $e->getMessage() . "\n");
}
?>