<?php
// Pages may set $page_title, $page_description, $page_url, $page_image before
// including this header to override the defaults below.
$default_title = 'Microbial Clinical Atlas';
$default_desc  = 'A curated knowledge base of clinically relevant microbes — Taxon Passports linking microorganisms to ecology, clinical role, and evidence-graded literature.';
$default_url   = 'https://mca.thebiohub.ca' . ($_SERVER['REQUEST_URI'] ?? '/');
$default_image = 'https://mca.thebiohub.ca/images/logo.png';

$meta_title = htmlspecialchars($page_title       ?? $default_title, ENT_QUOTES);
$meta_desc  = htmlspecialchars($page_description ?? $default_desc,  ENT_QUOTES);
$meta_url   = htmlspecialchars($page_url         ?? $default_url,   ENT_QUOTES);
$meta_image = htmlspecialchars($page_image       ?? $default_image, ENT_QUOTES);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $meta_title ?></title>
    <meta name="description" content="<?= $meta_desc ?>">

    <!-- Open Graph (for Slack, Facebook, LinkedIn link previews) -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="<?= $meta_title ?>">
    <meta property="og:description" content="<?= $meta_desc ?>">
    <meta property="og:url" content="<?= $meta_url ?>">
    <meta property="og:image" content="<?= $meta_image ?>">
    <meta property="og:site_name" content="Microbial Clinical Atlas">

    <!-- Twitter card -->
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="<?= $meta_title ?>">
    <meta name="twitter:description" content="<?= $meta_desc ?>">
    <meta name="twitter:image" content="<?= $meta_image ?>">

    <link rel="icon" type="image/x-icon" href="images/favicon.ico">
    <link rel="stylesheet" href="css/style.css?v=2">
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-WSKVZK9N');</script>
    <!-- End Google Tag Manager -->
</head>
<body>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WSKVZK9N"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<nav class="navbar">
    <a href="index.php" class="navbar-brand">Microbial Clinical Atlas</a>
    <div style="display: flex; gap: 20px;">
        <a href="about.php" style="color: white; font-weight: bold;">About</a>
        <a href="advanced_search.php" style="color: white; font-weight: bold;">Search</a>
        <a href="passports.php" style="color: white; font-weight: bold;">Passports</a>
    </div>
</nav>