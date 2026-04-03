<?php
require_once 'db_connect.php';

$filter_rank       = isset($_GET['rank'])       ? trim($_GET['rank'])       : '';
$filter_domain     = isset($_GET['domain'])     ? trim($_GET['domain'])     : '';
$filter_name       = isset($_GET['name'])       ? trim($_GET['name'])       : '';
$filter_pathobiont = isset($_GET['pathobiont']) ? trim($_GET['pathobiont']) : '';
$filter_role       = isset($_GET['role'])       ? trim($_GET['role'])       : '';
$filter_evidence   = isset($_GET['evidence'])   ? trim($_GET['evidence'])   : '';

$allowed_rank       = ['family', 'genus', 'species', 'subspecies', 'strain', 'clade'];
$allowed_domain     = ['Bacteria', 'Fungi', 'Virus', 'Archaea', 'Eukaryote'];
$allowed_pathobiont = ['yes', 'no', 'context dependent', 'unknown'];
$allowed_role       = ['opportunistic pathogen', 'primary pathogen', 'protective commensal', 'commensal', 'probiotic candidate', 'biofilm former', 'coloniser', 'unknown'];
$allowed_evidence   = ['E3', 'E2', 'E1'];

if (!in_array($filter_rank, $allowed_rank))             $filter_rank = '';
if (!in_array($filter_domain, $allowed_domain))         $filter_domain = '';
if (!in_array($filter_pathobiont, $allowed_pathobiont)) $filter_pathobiont = '';
if (!in_array($filter_role, $allowed_role))             $filter_role = '';
if (!in_array($filter_evidence, $allowed_evidence))     $filter_evidence = '';
// name is free-text; sanitised via PDO binding

try {
    $where_clauses = [];
    $params = [];

    if ($filter_rank !== '') {
        $where_clauses[] = 'p.taxon_rank = ?';
        $params[] = $filter_rank;
    }
    if ($filter_domain !== '') {
        $where_clauses[] = 'p.domain = ?';
        $params[] = $filter_domain;
    }
    if ($filter_name !== '') {
        $where_clauses[] = 'p.preferred_name LIKE ?';
        $params[] = '%' . $filter_name . '%';
    }
    if ($filter_pathobiont !== '') {
        $where_clauses[] = 'p.is_pathobiont = ?';
        $params[] = $filter_pathobiont;
    }
    if ($filter_role !== '') {
        $where_clauses[] = 'EXISTS (SELECT 1 FROM taxon_tag rt WHERE rt.passport_id = p.id AND rt.category = \'role\' AND rt.value = ?)';
        $params[] = $filter_role;
    }

    $where_sql  = $where_clauses ? 'WHERE ' . implode(' AND ', $where_clauses) : '';
    $having_sql = '';
    $having_params = [];
    if ($filter_evidence !== '') {
        $having_sql = 'HAVING MAX(a.evidence_level) = ?';
        $having_params[] = $filter_evidence;
    }

    $stmt = $pdo->prepare("
        SELECT
            p.passport_id,
            p.preferred_name,
            p.taxon_rank,
            p.domain,
            p.is_pathobiont,
            GROUP_CONCAT(DISTINCT t.value ORDER BY t.value SEPARATOR '; ') as roles,
            MAX(a.evidence_level) as top_evidence
        FROM passport p
        LEFT JOIN taxon_tag t ON t.passport_id = p.id AND t.category = 'role'
        LEFT JOIN association a ON a.passport_id = p.id
        $where_sql
        GROUP BY p.id
        $having_sql
        ORDER BY p.passport_id ASC
    ");
    $params = array_merge($params, $having_params);
    $stmt->execute($params);
    $all_taxa = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $filtered_count = count($all_taxa);

    $total_stmt = $pdo->query("SELECT COUNT(*) FROM passport");
    $total_count = (int)$total_stmt->fetchColumn();
} catch (PDOException $e) {
    die("Database Error: " . $e->getMessage());
}

$is_filtered = ($filter_rank !== '' || $filter_domain !== '' || $filter_name !== '' || $filter_pathobiont !== '' || $filter_role !== '' || $filter_evidence !== '');

function build_filter_url($overrides = []) {
    $keys = ['rank', 'domain', 'name', 'pathobiont', 'role', 'evidence'];
    $parts = [];
    foreach ($keys as $k) {
        $val = $overrides[$k] ?? ($_GET[$k] ?? '');
        if ($val !== '') $parts[] = urlencode($k) . '=' . urlencode($val);
    }
    return 'passports.php' . ($parts ? '?' . implode('&', $parts) : '');
}

include 'header.php';
?>

<style>
    .table-row-link {
        border-bottom: 1px solid #eee;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    .table-row-link:hover { background-color: #fcfcfc; }
    .table-row-link:last-child { border-bottom: none; }
    .badge-rank {
        background: #f0f0f0;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 12px;
        text-transform: capitalize;
    }
    .filter-bar { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; margin-bottom: 20px; padding: 14px 16px; background: #f8f9fa; border-radius: 6px; border: 1px solid #eee; }
    .filter-bar select { padding: 5px 10px; border-radius: 4px; border: 1px solid #ccc; font-size: 13px; background: #fff; color: #333; cursor: pointer; }
    .filter-bar select:focus { outline: none; border-color: #404f7c; }
    .filter-reset { font-size: 12px; color: #888; text-decoration: none; margin-left: 6px; }
    .filter-reset:hover { color: #404f7c; text-decoration: underline; }
    .view-toggle-btn { padding: 5px 14px; border-radius: 4px; border: 1px solid #ccc; font-size: 12px; font-weight: 700; cursor: pointer; background: #fff; color: #555; letter-spacing: 0.5px; transition: background 0.15s; }
    .view-toggle-btn.active { background: #404f7c; color: #fff; border-color: #404f7c; }
    #card-grid { display: none; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-top: 16px; }
    #card-grid.visible { display: grid; }
    @media (max-width: 900px) {
        #card-grid { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 700px) {
        #table-view { display: none !important; }
        #card-grid { display: grid !important; grid-template-columns: 1fr; }
        .view-toggle-wrap { display: none !important; }
    }
    .passport-card { display: flex; flex-direction: column; gap: 8px; padding: 16px; border-radius: 6px; background: #fff; border: 1px solid #e5e7eb; text-decoration: none; color: #222; transition: box-shadow 0.15s, border-color 0.15s; cursor: pointer; }
    .passport-card:hover { box-shadow: 0 2px 10px rgba(64,79,124,0.12); border-color: #b0b8d0; }
    .pc-row1 { font-family: monospace; font-size: 11px; color: #aaa; }
    .pc-row2 { display: flex; align-items: baseline; gap: 8px; flex-wrap: wrap; }
    .pc-name { font-style: italic; font-weight: 700; font-size: 15px; color: #1a1a1a; }
    .pc-domain { font-size: 12px; color: #888; }
    .pc-row3 { display: flex; align-items: center; gap: 5px; flex-wrap: wrap; }
    .pc-pathobiont-yes { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 10px; font-weight: 700; text-transform: uppercase; background: #007bff; color: #fff; }
    .pc-pathobiont-other { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 10px; font-weight: 700; text-transform: uppercase; background: #f3f4f6; color: #6b7280; border: 1px solid #d1d5db; }
    .pc-pathobiont-context { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 10px; font-weight: 700; text-transform: uppercase; background: #4b5563; color: #fff; }
    .pc-role-pill { display: inline-block; padding: 2px 7px; border-radius: 3px; font-size: 10px; background: #f0f4ff; color: #404f7c; border: 1px solid #d0d8f0; }
    .pc-divider { color: #ddd; font-size: 10px; }
    .ev-badge { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; }
    .ev-E3 { background: #dbeafe; color: #1e40af; }
    .ev-E2 { background: #fef9c3; color: #854d0e; }
    .ev-E1 { background: #f3f4f6; color: #6b7280; }
    #table-view { }
    #table-view.hidden { display: none; }
    .th-tooltip { position: relative; cursor: help; border-bottom: 1px dotted #aaa; }
    .th-tooltip .tooltip-box {
        display: none; position: absolute; top: calc(100% + 6px); left: 0;
        background: #222; color: #fff; font-size: 12px; font-weight: 400;
        white-space: nowrap; padding: 8px 12px; border-radius: 5px;
        line-height: 1.8; z-index: 100; box-shadow: 0 2px 8px rgba(0,0,0,0.25);
    }
    .th-tooltip .tooltip-box::before {
        content: ''; position: absolute; bottom: 100%; left: 12px;
        border: 5px solid transparent; border-bottom-color: #222;
    }
    .th-tooltip:hover .tooltip-box { display: block; }
</style>

<div class="page-content">
    <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 16px;">
        <h2 style="margin: 0;">Taxon Passports</h2>
        <div class="view-toggle-wrap" style="display: flex; gap: 6px; align-items: center;">
            <button class="view-toggle-btn active" id="btn-table" onclick="setView('table')">Table</button>
            <button class="view-toggle-btn" id="btn-cards" onclick="setView('cards')">Cards</button>
        </div>
    </div>

    <form method="get" action="passports.php" id="filter-form">
        <div class="filter-bar">
            <label style="font-size: 12px; font-weight: 700; color: #555;">Rank:
                <select name="rank" onchange="document.getElementById('filter-form').submit()">
                    <option value="">All</option>
                    <?php foreach (['family','genus','species','subspecies','strain','clade'] as $opt): ?>
                        <option value="<?php echo htmlspecialchars($opt); ?>" <?php echo ($filter_rank === $opt ? 'selected' : ''); ?>><?php echo htmlspecialchars(ucfirst($opt)); ?></option>
                    <?php endforeach; ?>
                </select>
            </label>
            <label style="font-size: 12px; font-weight: 700; color: #555;">Name:
                <input type="text" name="name" value="<?php echo htmlspecialchars($filter_name); ?>" placeholder="e.g. Clostrid…" style="padding: 5px 8px; border-radius: 4px; border: 1px solid #ccc; font-size: 13px; width: 130px;" onchange="document.getElementById('filter-form').submit()">
            </label>
            <label style="font-size: 12px; font-weight: 700; color: #555;">Pathobiont:
                <select name="pathobiont" onchange="document.getElementById('filter-form').submit()">
                    <option value="">All</option>
                    <?php foreach (['yes','no','context dependent','unknown'] as $opt): ?>
                        <option value="<?php echo htmlspecialchars($opt); ?>" <?php echo ($filter_pathobiont === $opt ? 'selected' : ''); ?>><?php echo htmlspecialchars(ucfirst($opt)); ?></option>
                    <?php endforeach; ?>
                </select>
            </label>
            <label style="font-size: 12px; font-weight: 700; color: #555;">Clinical role:
                <select name="role" onchange="document.getElementById('filter-form').submit()">
                    <option value="">All</option>
                    <?php foreach (['opportunistic pathogen','primary pathogen','protective commensal','commensal','probiotic candidate','biofilm former','coloniser','unknown'] as $opt): ?>
                        <option value="<?php echo htmlspecialchars($opt); ?>" <?php echo ($filter_role === $opt ? 'selected' : ''); ?>><?php echo htmlspecialchars(ucfirst($opt)); ?></option>
                    <?php endforeach; ?>
                </select>
            </label>
            <label style="font-size: 12px; font-weight: 700; color: #555;">Evidence:
                <select name="evidence" onchange="document.getElementById('filter-form').submit()">
                    <option value="">All</option>
                    <?php foreach (['E3','E2','E1'] as $opt): ?>
                        <option value="<?php echo htmlspecialchars($opt); ?>" <?php echo ($filter_evidence === $opt ? 'selected' : ''); ?>><?php echo htmlspecialchars($opt); ?></option>
                    <?php endforeach; ?>
                </select>
            </label>
            <?php if ($is_filtered): ?>
                <a href="passports.php" class="filter-reset">Reset filters</a>
            <?php endif; ?>
        </div>
    </form>

    <div style="margin-bottom: 14px; font-size: 13px; color: #666;">
        <?php if ($is_filtered): ?>
            Showing <strong><?php echo $filtered_count; ?></strong> of <?php echo $total_count; ?> entries
        <?php else: ?>
            Showing all <strong><?php echo $total_count; ?></strong> entries
        <?php endif; ?>
    </div>

    <div id="table-view">
        <div class="card" style="padding: 0; overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; font-size: 15px; min-width: 600px;">
                <thead>
                    <tr style="background-color: #f8f9fa; border-bottom: 2px solid #eee; text-align: left;">
                        <th style="padding: 12px 15px;">ID</th>
                        <th style="padding: 12px 15px;">Rank</th>
                        <th style="padding: 12px 15px;">Domain</th>
                        <th style="padding: 12px 15px;">Preferred name</th>
                        <th style="padding: 12px 15px;">
                            <span class="th-tooltip">Evidence
                                <div class="tooltip-box">
                                    <strong>Evidence grade</strong><br>
                                    E3 = Strong human clinical evidence<br>
                                    E2 = Moderate human evidence<br>
                                    E1 = Limited / preliminary
                                </div>
                            </span>
                        </th>
                        <th style="padding: 12px 15px;">
                            <span class="th-tooltip">Pathobiont
                                <div class="tooltip-box">
                                    <strong>Pathobiont status</strong><br>
                                    YES &nbsp;= confirmed pathobiont<br>
                                    CD &nbsp;&nbsp;= Context Dependent<br>
                                    NO &nbsp;&nbsp;= not a pathobiont<br>
                                    UK &nbsp;&nbsp;= Unknown
                                </div>
                            </span>
                        </th>
                        <th style="padding: 12px 15px;">Clinical roles</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($all_taxa as $taxon): ?>
                        <?php
                            $ev = $taxon['top_evidence'] ?? null;
                            $ev_class = $ev ? 'ev-' . htmlspecialchars($ev) : '';
                        ?>
                        <tr class="table-row-link" onclick="window.location.href='passport.php?id=<?php echo urlencode($taxon['passport_id']); ?>'">
                            <td style="padding: 12px 15px; font-family: monospace; font-size: 11px; color: #555; white-space: nowrap;">
                                <?php echo htmlspecialchars($taxon['passport_id']); ?>
                            </td>
                            <td style="padding: 12px 15px;">
                                <span class="badge-rank"><?php echo htmlspecialchars($taxon['taxon_rank']); ?></span>
                            </td>
                            <td style="padding: 12px 15px; font-size: 13px; color: #666;">
                                <?php echo htmlspecialchars($taxon['domain']); ?>
                            </td>
                            <td style="padding: 12px 15px;">
                                <strong style="font-style: italic; color: #000;">
                                    <?php echo htmlspecialchars($taxon['preferred_name']); ?>
                                </strong>
                            </td>
                            <td style="padding: 12px 15px;">
                                <?php if ($ev): ?>
                                    <span class="ev-badge <?php echo $ev_class; ?>"><?php echo htmlspecialchars($ev); ?></span>
                                <?php endif; ?>
                            </td>
                            <td style="padding: 12px 15px;">
                                <?php if ($taxon['is_pathobiont'] === 'yes'): ?>
                                    <span class="pc-pathobiont-yes">Yes</span>
                                <?php elseif ($taxon['is_pathobiont'] === 'context dependent'): ?>
                                    <span class="pc-pathobiont-context">CD</span>
                                <?php elseif ($taxon['is_pathobiont'] === 'unknown'): ?>
                                    <span class="pc-pathobiont-other">UK</span>
                                <?php else: ?>
                                    <span class="pc-pathobiont-other"><?php echo htmlspecialchars($taxon['is_pathobiont']); ?></span>
                                <?php endif; ?>
                            </td>
                            <td style="padding: 12px 15px; font-size: 13px; color: #666;">
                                <?php echo $taxon['roles'] ? htmlspecialchars($taxon['roles']) : ''; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>

    <div id="card-grid">
        <?php foreach ($all_taxa as $taxon): ?>
            <?php $ev_c = $taxon['top_evidence'] ?? null; ?>
            <div class="passport-card" onclick="window.location.href='passport.php?id=<?php echo urlencode($taxon['passport_id']); ?>'">
                <!-- Row 1: ID -->
                <div class="pc-row1"><?php echo htmlspecialchars($taxon['passport_id']); ?></div>

                <!-- Row 2: Preferred name · Rank · Domain -->
                <div class="pc-row2">
                    <span class="pc-name"><?php echo htmlspecialchars($taxon['preferred_name']); ?></span>
                    <span class="badge-rank"><?php echo htmlspecialchars($taxon['taxon_rank']); ?></span>
                    <span class="pc-domain"><?php echo htmlspecialchars($taxon['domain']); ?></span>
                </div>

                <!-- Row 3: Pathobiont · Clinical roles · Evidence -->
                <div class="pc-row3">
                    <?php if ($taxon['is_pathobiont'] === 'yes'): ?>
                        <span class="pc-pathobiont-yes">Yes</span>
                    <?php elseif ($taxon['is_pathobiont'] === 'context dependent'): ?>
                        <span class="pc-pathobiont-context">CD</span>
                    <?php elseif ($taxon['is_pathobiont'] === 'unknown'): ?>
                        <span class="pc-pathobiont-other">UK</span>
                    <?php else: ?>
                        <span class="pc-pathobiont-other"><?php echo htmlspecialchars($taxon['is_pathobiont']); ?></span>
                    <?php endif; ?>
                    <?php if ($taxon['roles']): ?>
                        <span class="pc-divider">|</span>
                        <?php foreach (explode('; ', $taxon['roles']) as $role): ?>
                            <span class="pc-role-pill"><?php echo htmlspecialchars(trim($role)); ?></span>
                        <?php endforeach; ?>
                    <?php endif; ?>
                    <?php if ($ev_c): ?>
                        <span class="pc-divider">|</span>
                        <span class="ev-badge ev-<?php echo htmlspecialchars($ev_c); ?>"><?php echo htmlspecialchars($ev_c); ?></span>
                    <?php endif; ?>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</div>

<script>
    function setView(v) {
        const tableView = document.getElementById('table-view');
        const cardGrid  = document.getElementById('card-grid');
        const btnTable  = document.getElementById('btn-table');
        const btnCards  = document.getElementById('btn-cards');
        if (v === 'cards') {
            tableView.classList.add('hidden');
            cardGrid.classList.add('visible');
            btnTable.classList.remove('active');
            btnCards.classList.add('active');
        } else {
            tableView.classList.remove('hidden');
            cardGrid.classList.remove('visible');
            btnCards.classList.remove('active');
            btnTable.classList.add('active');
        }
        try { localStorage.setItem('mca_passports_view', v); } catch(e) {}
    }

    (function() {
        try {
            const saved = localStorage.getItem('mca_passports_view');
            if (saved === 'cards') setView('cards');
        } catch(e) {}
    })();
</script>

<?php include 'footer.php'; ?>
