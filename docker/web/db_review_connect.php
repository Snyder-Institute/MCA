<?php
// Docker-only db_review_connect.php — credentials match
// docker/mysql/init/04_users.sql. Mounted into the php container at
// /var/www/mca/db_review_connect.php.
//
// Reviews pages must use $pdo_review (not $pdo) so they cannot accidentally
// touch the canonical MCA database.

$host    = 'mysql';
$db      = 'MCA_review';
$user    = 'mca_review';
$pass    = 'mca_review';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo_review = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    error_log($e->getMessage());
    exit('Review database connection failed.');
}
