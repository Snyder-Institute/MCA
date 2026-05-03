#!/bin/bash
# deploy_review_to_production.sh — one-shot production deploy of the review system.
#
# Run from repo root:
#   bash scripts/deploy_review_to_production.sh
#
# Reads MYSQL_ROOT_PASS from env or prompts. Generates a strong mca_review
# password, persists it inside ${PROD_DOCROOT}/db_review_connect.php on the
# server (apache:apache 640), and writes it back to ~/.mca_review_pass on
# this laptop so the local Python scripts can connect.
#
# After this script finishes successfully, run cleanup:
#   shred -u ~/.mca_review_pass
# and rotate the MySQL root password.

set -euo pipefail

# ── Config ───────────────────────────────────────────────────────────────
SSH_KEY="$HOME/.ssh/thebiohub-ec2.pem"
SSH_HOST="rocky@40.177.172.211"
PROD_BASE_URL="https://mca.thebiohub.ca"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TUNNEL_PORT=33306
# Production docroot (nginx root): /srv/mca-repo/web/ (git-pull style, not ${PROD_DOCROOT}/).
PROD_DOCROOT="/srv/mca-repo/web"
PROD_REVIEW_DATA="/var/www/review_data"

# ── Sanity checks ────────────────────────────────────────────────────────
[[ -r "$SSH_KEY" ]] || { echo "missing SSH key: $SSH_KEY"; exit 1; }
[[ -d "$REPO_ROOT/web" ]] || { echo "web/ missing"; exit 1; }
[[ -d "$REPO_ROOT/review_data/pdfs" ]] || { echo "review_data/pdfs/ missing — run sync_review_data.py first"; exit 1; }
command -v python3 >/dev/null
command -v rsync >/dev/null

# ── 0. MySQL root password ───────────────────────────────────────────────
if [[ -z "${MYSQL_ROOT_PASS:-}" ]]; then
  read -rsp "MySQL root password: " MYSQL_ROOT_PASS
  echo
fi
[[ -n "$MYSQL_ROOT_PASS" ]] || { echo "no root password"; exit 1; }

# Reuse existing mca_review password if a previous run already created one
# and saved it at ~/.mca_review_pass (so re-running the script after a
# partial failure doesn't drift the user's actual password).
if [[ -s "$HOME/.mca_review_pass" ]]; then
  MCA_REVIEW_PASS=$(< "$HOME/.mca_review_pass")
  echo "Reusing existing mca_review password from ~/.mca_review_pass"
else
  RAND=$(openssl rand -base64 24 | tr -d '/+=' | head -c 20)
  MCA_REVIEW_PASS="A${RAND}9!a"
  umask 077
  printf '%s' "$MCA_REVIEW_PASS" > "$HOME/.mca_review_pass"
  echo "Generated mca_review password (saved to ~/.mca_review_pass)."
fi

ssh_run() { ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new "$SSH_HOST" "$@"; }
ssh_pipe_in() { ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new "$SSH_HOST" "$@"; }

# ── 1. Apply MCA_review schema ───────────────────────────────────────────
echo
echo "[1/9] Applying MCA_review schema..."
ssh_pipe_in "mysql -u root -p'${MYSQL_ROOT_PASS}'" \
  < "$REPO_ROOT/database/migrations/MCA_review/001_init.sql"

# ── 2. Create mca_review MySQL user ──────────────────────────────────────
echo "[2/9] Creating mca_review MySQL user..."
ssh_run "mysql -u root -p'${MYSQL_ROOT_PASS}' <<SQL
CREATE USER IF NOT EXISTS 'mca_review'@'localhost' IDENTIFIED BY '${MCA_REVIEW_PASS}';
GRANT SELECT ON MCA.* TO 'mca_review'@'localhost';
GRANT ALL PRIVILEGES ON MCA_review.* TO 'mca_review'@'localhost';
FLUSH PRIVILEGES;
SQL"

# ── 3. Write ${PROD_DOCROOT}/db_review_connect.php on server ────────────────
echo "[3/9] Writing ${PROD_DOCROOT}/db_review_connect.php..."
ssh_run "sudo tee ${PROD_DOCROOT}/db_review_connect.php > /dev/null <<PHP
<?php
\\\$host    = 'localhost';
\\\$db      = 'MCA_review';
\\\$user    = 'mca_review';
\\\$pass    = '${MCA_REVIEW_PASS}';
\\\$charset = 'utf8mb4';
\\\$dsn = \"mysql:host=\\\$host;dbname=\\\$db;charset=\\\$charset\";
\\\$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];
try {
    \\\$pdo_review = new PDO(\\\$dsn, \\\$user, \\\$pass, \\\$options);
} catch (\\\\PDOException \\\$e) {
    error_log(\\\$e->getMessage());
    exit('Review database connection failed.');
}
PHP
sudo chown apache:apache ${PROD_DOCROOT}/db_review_connect.php
sudo chmod 640 ${PROD_DOCROOT}/db_review_connect.php
sudo restorecon -v ${PROD_DOCROOT}/db_review_connect.php"

# ── 4. Patch nginx vhost: add db_review_connect to deny block ────────────
echo "[4/9] Updating nginx deny block..."
ssh_run "sudo sed -i 's|location ~ \\^/(db_connect\\\\|db_connect_template)\\\\\\\\.php\\$|location ~ ^/(db_connect\\\\|db_connect_template\\\\|db_review_connect)\\\\.php\$|' /etc/nginx/conf.d/mca.conf
sudo nginx -t && sudo systemctl reload nginx"

# ── 5. rsync review-system PHP files ─────────────────────────────────────
echo "[5/9] rsync web/review*.php + web/api/ + robots.txt..."
rsync -avz -e "ssh -i $SSH_KEY" --include='review*.php' --include='robots.txt' --include='api/***' --exclude='*' \
  "$REPO_ROOT/web/" "$SSH_HOST:/tmp/mca_review_web_stage/"
ssh_run "sudo cp -r /tmp/mca_review_web_stage/. ${PROD_DOCROOT}/
sudo chown -R apache:apache ${PROD_DOCROOT}/review*.php ${PROD_DOCROOT}/api 2>/dev/null || true
sudo restorecon -Rv ${PROD_DOCROOT}/review*.php ${PROD_DOCROOT}/api 2>/dev/null || true
rm -rf /tmp/mca_review_web_stage"

# ── 6. rsync review_data/pdfs/ ───────────────────────────────────────────
echo "[6/9] rsync review_data/pdfs/ → ${PROD_REVIEW_DATA}/pdfs/..."
ssh_run "sudo mkdir -p ${PROD_REVIEW_DATA}/pdfs
sudo chown -R rocky:rocky ${PROD_REVIEW_DATA}"
rsync -avz -e "ssh -i $SSH_KEY" "$REPO_ROOT/review_data/pdfs/" \
  "$SSH_HOST:${PROD_REVIEW_DATA}/pdfs/"
ssh_run "sudo chown -R apache:apache ${PROD_REVIEW_DATA}
sudo chmod -R 640 ${PROD_REVIEW_DATA}/pdfs/*.pdf
sudo find ${PROD_REVIEW_DATA} -type d -exec chmod 750 {} +
sudo restorecon -Rv ${PROD_REVIEW_DATA} 2>&1 | tail -3"

# ── 7. SSH tunnel + populate MCA_review on production ────────────────────
echo "[7/9] Opening SSH tunnel and populating production MCA_review..."
ssh -i "$SSH_KEY" -fN -L "$TUNNEL_PORT:localhost:3306" "$SSH_HOST"
TUNNEL_PID=$(pgrep -f "$TUNNEL_PORT:localhost:3306" | tail -1)
trap "kill $TUNNEL_PID 2>/dev/null || true" EXIT

export MCA_DB_HOST=127.0.0.1
export MCA_DB_PORT=$TUNNEL_PORT
export MCA_DB_USER=mca_review
export MCA_DB_PASS="$MCA_REVIEW_PASS"

cd "$REPO_ROOT"
echo "  extract_abstracts.py..."
python3 scripts/extract_abstracts.py
echo "  ingest_for_review.py..."
python3 scripts/ingest_for_review.py --truncate

# ── 8. Mint 10 tokens with production URL base ───────────────────────────
echo "[8/9] Minting 10 tokens with production URL base..."
export MCA_REVIEW_BASE_URL="$PROD_BASE_URL"
python3 scripts/mint_tokens.py 10

# ── 9. Append soft-deadline note to tokens.md ────────────────────────────
TOKENS_MD=$(python3 -c "import sys, os; sys.path.insert(0,'scripts'); import _paths; print(_paths.cycle_dir() / 'tokens.md')")
cat >> "$TOKENS_MD" <<EOF

## Soft deadline

Please complete your review by **June 30, 2026**. The cycle will not freeze
automatically — the curator will close it manually shortly after the
deadline.
EOF
echo "[9/9] Soft-deadline note appended to: $TOKENS_MD"

# Also place a copy on the curator's Desktop for quick access.
DESKTOP_COPY="$HOME/Desktop/review_tokens_$(date +%Y-%m-%d).md"
cp "$TOKENS_MD" "$DESKTOP_COPY"
echo "        Copy on Desktop:           $DESKTOP_COPY"

# Tear down tunnel explicitly
kill $TUNNEL_PID 2>/dev/null || true

echo
echo "=============================================================="
echo "Production deploy complete."
echo "  Tokens written to: $TOKENS_MD"
echo "  mca_review password lives in ~/.mca_review_pass and on server"
echo "  in ${PROD_DOCROOT}/db_review_connect.php (apache:apache 640)."
echo
echo "Next:"
echo "  1. Email URLs from $TOKENS_MD to invited reviewers."
echo "  2. After this, rotate the MySQL root password."
echo "  3. shred -u ~/.mca_review_pass when you no longer need it."
echo "=============================================================="
