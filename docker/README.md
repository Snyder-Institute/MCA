# MCA local dev stack (Docker)

Mirrors production: nginx 1.20, PHP-FPM 8.3, MySQL 8.4. All credentials in this directory are dev-only and confined to localhost.

## Start

From the repo root:

```bash
docker compose -f docker/docker-compose.yml up -d
```

First run pulls images and imports the latest MCA dump (~1 minute). Subsequent runs are instant.

Visit:
- `http://localhost:8080` — MCA homepage
- `http://localhost:8080/MCA-BAC-000001` — passport (verifies clean URLs work)
- `http://localhost:8080/passports` — extensionless PHP routing
- `mysql -h 127.0.0.1 -P 13306 -u root -proot` — direct DB access

## Wipe and restart

```bash
docker compose -f docker/docker-compose.yml down -v
```

`-v` removes the persistent MySQL volume so the next `up` re-imports the schema and data from scratch.

## What's mounted

- `web/` (host) → `/var/www/mca` (php + nginx, read-only on nginx). Live edits — refresh and see them.
- `database/MCA_create_database.sql.gz` → MySQL init (creates `MCA` schema)
- `database/MCA_DB_v1_10_20260404.sql.gz` → MySQL init (loads v1.10 data)
- `database/migrations/MCA_review/001_init.sql` → MySQL init (creates `MCA_review`)
- `docker/mysql/init/04_users.sql` → creates `mca` and `mca_review` users
- `docker/web/db_connect.php` and `docker/web/db_review_connect.php` → credentials for the two app users (override the gitignored prod copies)

## Versions pinned to production

| Component | Local | Production |
|---|---|---|
| nginx | 1.20 | 1.20.1 |
| PHP-FPM | 8.3 | 8.3.30 |
| MySQL | 8.4 | 8.4.9 |

When production upgrades, bump these here too.

## What this stack does NOT mirror

- TLS / HTTPS (production uses Let's Encrypt). Local is plain HTTP.
- SELinux contexts (only matter on Rocky).
- File ownership rules (`apache:apache 640`). Docker runs as the image's default user.
- The `apache` PHP-FPM user (Rocky-specific). Container PHP-FPM runs as `www-data`.

These differences only matter for ops, not for testing review-system behavior.
