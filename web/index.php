<?php
include 'header.php';
?>

<div class="page-content">
    <div class="logo-container">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <div class="google-search-container" style="margin-top: 80px;">
        <input type="text" id="microbe-search" placeholder="Search by name (e.g. Enterobacteriaceae)" autocomplete="off" autofocus>
        <div id="search-results"></div>
    </div>
</div>

<script>
const placeholders = [
    "Search by name (e.g. Enterobacteriaceae)",
    "Search by synonym (e.g. Enterobacteraceae)",
    "Search by ID (e.g. MCA-BAC-000001)"
];
let currentPlaceholderIndex = 0;

setInterval(() => {
    currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.length;
    document.getElementById('microbe-search').placeholder = placeholders[currentPlaceholderIndex];
}, 5000);
</script>

<?php include 'footer.php'; ?>
