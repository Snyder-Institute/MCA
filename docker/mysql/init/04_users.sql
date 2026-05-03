-- ============================================================
-- MCA local dev users (docker-only)
--
-- These passwords are for the local docker stack only — they
-- match what docker/web/db_connect.php and
-- docker/web/db_review_connect.php expect. They are not used
-- in production and are safe to commit.
-- ============================================================

CREATE USER IF NOT EXISTS 'mca'@'%' IDENTIFIED BY 'mca';
GRANT ALL PRIVILEGES ON MCA.* TO 'mca'@'%';

CREATE USER IF NOT EXISTS 'mca_review'@'%' IDENTIFIED BY 'mca_review';
GRANT ALL PRIVILEGES ON MCA_review.* TO 'mca_review'@'%';
-- Read-only on MCA so review pages cannot accidentally modify the canonical KB.
GRANT SELECT ON MCA.* TO 'mca_review'@'%';

FLUSH PRIVILEGES;
