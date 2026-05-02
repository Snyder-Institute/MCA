<?php
// ============================================================================
// MCA database connection
// ============================================================================
// 1. Copy this file to db_connect.php (db_connect.php is gitignored).
// 2. Fill in your real DB credentials below.
// 3. On a Linux server with nginx + PHP-FPM, set ownership so PHP can read
//    the file but the world cannot. PHP-FPM on Rocky/RHEL runs as `apache`;
//    on Debian/Ubuntu it runs as `www-data`. Adjust accordingly:
//
//      sudo chown apache:apache web/db_connect.php   # Rocky/RHEL
//      sudo chmod 640 web/db_connect.php
//
//    If owned by nginx:nginx or root:root with 640, PHP returns HTTP 500
//    with "Permission denied" in /var/log/php-fpm/www-error.log.
// 4. Block direct HTTP access in your nginx vhost:
//
//      location ~ ^/(db_connect|db_connect_template)\.php$ {
//          deny all;
//          return 404;
//      }
// ============================================================================

$host    = 'localhost';
$db      = 'MCA';
$user    = 'mca';
$pass    = 'password';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
     error_log($e->getMessage());
     exit('Database connection failed.');
}
?>
