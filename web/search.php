<?php
require_once 'db_connect.php';

$search_query = isset($_GET['q']) ? trim($_GET['q']) : '';
$results = [];
$tag_match_categories = [];

if ($search_query !== '') {
    $term = '%' . $search_query . '%';
    try {
        $stmt = $pdo->prepare("
            SELECT DISTINCT p.passport_id, p.preferred_name, p.taxon_rank, p.lineage,
                   NULL as match_category
            FROM passport p
            LEFT JOIN taxon_tag s ON s.passport_id = p.id AND s.category = 'synonym'
            WHERE p.preferred_name LIKE ?
               OR p.passport_id LIKE ?
               OR s.value LIKE ?
            UNION
            SELECT DISTINCT p.passport_id, p.preferred_name, p.taxon_rank, p.lineage,
                   t2.category as match_category
            FROM passport p
            INNER JOIN taxon_tag t2 ON t2.passport_id = p.id
                AND t2.category IN ('primary_niche','role','bloom_trigger','risk_context','typical_specimen')
                AND t2.value LIKE ?
            ORDER BY preferred_name ASC
        ");
        $stmt->execute([$term, $term, $term, $term]);
        $raw_results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $seen = [];
        foreach ($raw_results as $row) {
            $pid = $row['passport_id'];
            if (!isset($seen[$pid])) {
                $seen[$pid] = $row;
                $seen[$pid]['match_categories'] = [];
            }
            if (!empty($row['match_category'])) {
                $seen[$pid]['match_categories'][] = $row['match_category'];
            }
        }
        $results = array_values($seen);

        if (count($results) === 1) {
            header("Location: " . $results[0]['passport_id']);
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
                    <tr style="border-bottom: 1px solid #eee; cursor: pointer;" onclick="window.location.href='<?php echo $row['passport_id']; ?>'">
                        <td style="padding: 15px 10px;">
                            <div style="font-weight: bold; font-style: italic; color: #007bff;"><?php echo htmlspecialchars($row['preferred_name']); ?></div>
                            <div style="font-size: 11px; color: #999; margin-top: 4px;"><?php echo htmlspecialchars(str_replace(';', ' |', $row['lineage'])); ?></div>
                            <?php if (!empty($row['match_categories'])): ?>
                                <div style="margin-top: 5px;">
                                    <?php foreach (array_unique($row['match_categories']) as $cat): ?>
                                        <span style="display: inline-block; padding: 1px 6px; border-radius: 3px; font-size: 10px; background: #eef0f8; color: #404f7c; border: 1px solid #c8cde8; margin-right: 4px;">matched via <?php echo htmlspecialchars($cat); ?></span>
                                    <?php endforeach; ?>
                                </div>
                            <?php endif; ?>
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
