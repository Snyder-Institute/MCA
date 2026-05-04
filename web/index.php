<?php
include 'header.php';
?>

<div class="page-content">
    <div class="logo-container">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <p style="text-align: center; max-width: 640px; margin: 32px auto 0; color: #666; font-size: 16px; line-height: 1.6;">
        A curated knowledge base of clinically relevant microbes &mdash;
        each <strong>Taxon Passport</strong> links a microorganism to its
        ecology, clinical role, and evidence-graded literature.
    </p>

    <div class="google-search-container" style="margin-top: 32px;">
        <input type="text" id="microbe-search" placeholder="Search by name (e.g. Enterobacteriaceae)" autocomplete="off" autofocus>
        <div id="search-results"></div>
    </div>

    <div style="margin-top: 48px; text-align: center;">
        <a href="https://apps.apple.com/app/microbial-clinical-atlas/id6761735200" target="_blank" rel="noopener noreferrer">
            <img src="./images/appstore_badge.png" alt="Download on the App Store" style="height: 44px;">
        </a>
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
