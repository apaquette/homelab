#!/usr/bin/env bash
set -Eeuo pipefail

BACKUP_ROOT="/mnt/backup/Backup/Nextcloud"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_DIR="${BACKUP_ROOT}/snapshots/${TIMESTAMP}"

CONTAINER_NEXTCLOUD="nextcloud"
CONTAINER_POSTGRES="nextcloud_postgres"

BACKUP_SUCCESS=false

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

cleanup() {
    local exit_code=$?

    log "Disabling Nextcloud maintenance mode..."
    docker exec --user www-data "$CONTAINER_NEXTCLOUD" \
        php occ maintenance:mode --off >/dev/null 2>&1 || true

    if [[ "$BACKUP_SUCCESS" != true && -d "$BACKUP_DIR" ]]; then
        log "Backup failed; removing incomplete snapshot"
        rm -rf -- "$BACKUP_DIR"
    fi

    exit "$exit_code"
}

trap cleanup EXIT

log "Starting Nextcloud backup: ${TIMESTAMP}"

mkdir -p "$BACKUP_DIR"/{database,files,compose}

chmod 700 "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"/{database,files,compose}

log "Enabling Nextcloud maintenance mode..."
docker exec --user www-data "$CONTAINER_NEXTCLOUD" \
    php occ maintenance:mode --on

log "Creating PostgreSQL dump..."
docker exec "$CONTAINER_POSTGRES" \
    pg_dump -U nextcloud -d nextcloud \
    > "$BACKUP_DIR/database/nextcloud.sql"

chmod 600 "$BACKUP_DIR/database/nextcloud.sql"

log "Backing up Nextcloud application/configuration..."
tar -C /opt/nextcloud \
    --exclude='html/data' \
    -czf "$BACKUP_DIR/files/nextcloud-html.tar.gz" \
    html

log "Backing up Nextcloud user data..."
rsync -a --delete \
    /mnt/myraid/Nextcloud/ \
    "$BACKUP_DIR/files/data/"

log "Backing up Docker configuration..."
cp /opt/nextcloud/docker-compose.yml \
    "$BACKUP_DIR/compose/docker-compose.yml"

cp /opt/nextcloud/.env \
    "$BACKUP_DIR/compose/.env"

chmod 600 "$BACKUP_DIR/compose/.env"

log "Recording backup metadata..."
cat > "$BACKUP_DIR/backup-info.txt" <<EOF2
Backup timestamp: ${TIMESTAMP}
Hostname: $(hostname)
Nextcloud version: $(docker exec "$CONTAINER_NEXTCLOUD" php occ status --output=json | tr -d '\n')
EOF2

chmod 600 "$BACKUP_DIR/backup-info.txt"

BACKUP_SUCCESS=true

log "Backup completed successfully."

log "Removing backups older than 7 generations..."
find "$BACKUP_ROOT/snapshots" \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -printf '%T@ %p\n' |
    sort -nr |
    tail -n +8 |
    cut -d' ' -f2- |
    xargs -r rm -rf

log "Backup generations currently retained:"
find "$BACKUP_ROOT/snapshots" \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' |
    sort -r
