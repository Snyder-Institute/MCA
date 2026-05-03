FROM php:8.3-fpm

# MCA needs PDO MySQL for db_connect.php; everything else MCA uses ships
# with PHP core (json, file_get_contents, etc.).
RUN docker-php-ext-install pdo_mysql
