<?php
// Docker-only db_connect.php — credentials match docker/mysql/init/04_users.sql.
// Mounted into the php container at /var/www/mca/db_connect.php.

$host    = 'mysql';     // container hostname on the docker network
$db      = 'MCA';
$user    = 'mca';
$pass    = 'mca';
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
