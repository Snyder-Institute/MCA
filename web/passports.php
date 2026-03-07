<?php
require_once 'db_connect.php';

try {
    $stmt = $pdo->query("
        SELECT 
            p.passport_id, 
            p.preferred_name, 
            p.taxon_rank, 
            p.is_pathobiont,
            GROUP_CONCAT(r.role_text SEPARATOR '; ') as roles
        FROM mca_taxon_passport p
        LEFT JOIN mca_taxon_role r ON p.passport_id = r.passport_id
        GROUP BY p.passport_id
        ORDER BY p.passport_id ASC
    ");
    $all_taxa = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $total_count = count($all_taxa);
} catch (PDOException $e) {
    die("Database Error: " . $e->getMessage());
}

include 'header.php'; 
?>

<div class="page-content">
    <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 20px;">
        <h2 style="margin: 0;">Taxon Passports</h2>
        <span class="muted">Showing all <strong><?php echo $total_count; ?></strong> entries</span>
    </div>

    <div class="card" style="padding: 0; overflow: hidden;">
        <table style="width: 100%; border-collapse: collapse; font-size: 15px;">
            <thead>
                <tr style="background-color: #f8f9fa; border-bottom: 2px solid #eee; text-align: left;">
                    <th style="padding: 12px 15px;">ID</th>
                    <th style="padding: 12px 15px;">Preferred name</th>
                    <th style="padding: 12px 15px;">Rank</th>
                    <th style="padding: 12px 15px;">Pathobiont</th>
                    <th style="padding: 12px 15px;">Clinical roles</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($all_taxa as $taxon): ?>
                    <tr class="table-row-link" onclick="window.location.href='passport.php?id=<?php echo urlencode($taxon['passport_id']); ?>'">
                        <td style="padding: 12px 15px; font-family: monospace; color: #555;">
                            <?php echo htmlspecialchars($taxon['passport_id']); ?>
                        </td>
                        <td style="padding: 12px 15px;">
                            <strong style="font-style: italic; color: #000;">
                                <?php echo htmlspecialchars($taxon['preferred_name']); ?>
                            </strong>
                        </td>
                        <td style="padding: 12px 15px;">
                            <span class="badge-rank"><?php echo htmlspecialchars($taxon['taxon_rank']); ?></span>
                        </td>
                        <td style="padding: 12px 15px;">
                            <span class="<?php echo ($taxon['is_pathobiont'] === 'yes' ? 'pathobiont-alert' : 'muted'); ?>" style="font-size: 13px; font-weight: bold;">
                                <?php echo htmlspecialchars($taxon['is_pathobiont']); ?>
                            </span>
                        </td>
                        <td style="padding: 12px 15px; font-size: 13px; color: #666;">
                            <?php echo $taxon['roles'] ? htmlspecialchars($taxon['roles']) : '<span class="muted">n/a</span>'; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<style>
    .table-row-link {
        border-bottom: 1px solid #eee;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    .table-row-link:hover {
        background-color: #fcfcfc;
    }
    .table-row-link:last-child {
        border-bottom: none;
    }
    .badge-rank {
        background: #f0f0f0;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 12px;
        text-transform: capitalize;
    }
</style>

<?php include 'footer.php'; ?>