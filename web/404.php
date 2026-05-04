<?php
http_response_code(404);
?>
<meta http-equiv="refresh" content="5; url=https://mca.thebiohub.ca/">
<?php include 'header.php'; ?>

<div class="page-content" style="text-align: center; padding-top: 100px;">
    <div style="font-size: 96px; font-weight: 700; color: #404f7c; line-height: 1;">404</div>
    <p style="font-size: 24px; margin: 12px 0 8px; color: #333;">Sorry, we couldn't find that page.</p>
    <p style="color: #666; max-width: 560px; margin: 0 auto 24px; line-height: 1.6;">
        The link may be outdated, or the URL may have a typo.
        No worries &mdash; you can browse the
        <a href="passports.php" style="color: #404f7c; font-weight: bold;">full passport list</a>,
        or wait a moment and we'll take you home.
    </p>

    <p style="color: #888; font-size: 14px;">
        Returning to the homepage in <span id="countdown" style="font-weight: bold; color: #404f7c;">5</span> seconds&hellip;
    </p>
</div>

<script>
(function () {
    let secondsLeft = 5;
    const el = document.getElementById('countdown');
    const tick = setInterval(() => {
        secondsLeft -= 1;
        if (el) el.textContent = secondsLeft;
        if (secondsLeft <= 0) {
            clearInterval(tick);
            window.location.href = 'https://mca.thebiohub.ca/';
        }
    }, 1000);
})();
</script>

<?php include 'footer.php'; ?>
