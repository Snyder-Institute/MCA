<?php
require_once 'db_connect.php';

$search_query = isset($_GET['q']) ? trim($_GET['q']) : '';
$results = [];

if ($search_query !== '') {
    $term = '%' . $search_query . '%';
    
    try {
        $stmt = $pdo->prepare("
            SELECT DISTINCT p.passport_id, p.preferred_name, p.taxon_rank, p.lineage
            FROM mca_taxon_passport p
            LEFT JOIN mca_taxon_synonym s ON p.passport_id = s.passport_id
            WHERE p.preferred_name LIKE ? 
               OR p.passport_id LIKE ? 
               OR s.synonym LIKE ?
            ORDER BY p.preferred_name ASC
        ");
        
        $stmt->execute([$term, $term, $term]);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if (count($results) === 1) {
            header("Location: passport.php?id=" . urlencode($results[0]['passport_id']));
            exit;
        }
        
    } catch (PDOException $e) {
        die("Search error: " . $e->getMessage());
    }
}

include 'header.php';
?>

<div class="page-content">
    <div style="margin-bottom: 30px;">
        <a href="index.php" style="font-weight: bold; font-size: 12px; color: #000; text-decoration: none; letter-spacing: 1px;">&larr; BACK TO SEARCH</a>
    </div>

    <h2 style="font-size: 24px; margin-bottom: 20px;">Search results for: "<?php echo htmlspecialchars($search_query); ?>"</h2>
    <p style="color: #666; margin-bottom: 30px;"><?php echo count($results); ?> matches found.</p>

    <?php if (!empty($results)): ?>
        <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead>
                <tr style="border-bottom: 2px solid #000; text-align: left; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">
                    <th style="padding: 12px 10px;">Taxon Name</th>
                    <th style="padding: 12px 10px;">Rank</th>
                    <th style="padding: 12px 10px;">Passport ID</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($results as $row): ?>
                    <tr style="border-bottom: 1px solid #eee; cursor: pointer;" onclick="window.location.href='passport.php?id=<?php echo $row['passport_id']; ?>'">
                        <td style="padding: 15px 10px;">
                            <div style="font-weight: bold; font-style: italic; color: #007bff;"><?php echo htmlspecialchars($row['preferred_name']); ?></div>
                            <div style="font-size: 11px; color: #999; margin-top: 4px;"><?php echo htmlspecialchars(str_replace('|', ' | ', $row['lineage'])); ?></div>
                        </td>
                        <td style="padding: 15px 10px; text-transform: capitalize; font-size: 13px;"><?php echo htmlspecialchars($row['taxon_rank']); ?></td>
                        <td style="padding: 15px 10px; font-family: monospace; font-weight: bold;"><?php echo htmlspecialchars($row['passport_id']); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php else: ?>
        <div style="padding: 40px; background: #f9f9f9; border-radius: 4px; text-align: center; color: #666;">
            No microbes found matching your search.
        </div>
    <?php endif; ?>
</div>

<?php include 'footer.php'; ?>