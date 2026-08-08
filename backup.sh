#!/bin/bash
#
# backup.sh - Backs up a local directory to a remote host via rsync over SSH.
#
# Configuration is done via environment variables, with sensible defaults
# below. Example override:
#   SOURCE_DIR=/data REMOTE_USER=deploy REMOTE_HOST=192.168.1.10 ./backup.sh
#

set -uo pipefail

# ----- Configuration (override via environment variables) -----
SOURCE_DIR="${SOURCE_DIR:-$HOME/backup_source/}"
REMOTE_USER="${REMOTE_USER:-$USER}"
REMOTE_HOST="${REMOTE_HOST:-127.0.0.1}"   # loopback used as local demo target
REMOTE_DIR="${REMOTE_DIR:-$HOME/backup_dest/}"
LOG_FILE="${LOG_FILE:-$HOME/logs/backup.log}"

# ----- Functions -----

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

perform_backup() {
    rsync -avz "$SOURCE_DIR" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        log "Backup successful"
    else
        log "Backup failed"
        return 1
    fi
}

# ----- Main -----

mkdir -p "$(dirname "$LOG_FILE")"
perform_backup
