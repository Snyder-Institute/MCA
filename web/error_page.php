<?php
// Friendly server-error page. Caller should:
//   error_log("[<file>] " . $e->getMessage());
//   http_response_code(500);
//   require 'error_page.php';
//   exit;
include 'header.php';
?>

<div class="page-content" style="text-align: center; padding-top: 80px;">
    <div style="font-size: 96px; font-weight: 700; color: #404f7c; line-height: 1;">!</div>
    <p style="font-size: 24px; margin: 12px 0 8px; color: #333;">Something went wrong on our end.</p>
    <p style="color: #666; max-width: 560px; margin: 0 auto 24px; line-height: 1.6;">
        We couldn't load this page right now. Please try again in a moment, or browse the
        <a href="passports.php" style="color: #404f7c; font-weight: bold;">full passport list</a>.
    </p>
    <p style="margin: 0;">
        <a href="/" style="color: #404f7c; font-weight: bold;">&larr; Return to homepage</a>
    </p>
</div>

<?php include 'footer.php'; ?>
