#!/bin/bash
#
# logrotate.sh - Rotates and compresses log files that exceed a size
# threshold, and deletes rotated logs older than a set age.
#
# Configuration is done via environment variables, with sensible defaults
# below. Example override:
#   LOG_DIR=/var/log/myapp MAX_LOG_SIZE=10000000 ./logrotate.sh
#

set -uo pipefail

# ----- Configuration (override via environment variables) -----
LOG_DIR="${LOG_DIR:-$HOME/logs}"
MAX_LOG_SIZE="${MAX_LOG_SIZE:-5000000}"   # 5 MB, in bytes
MAX_LOG_AGE="${MAX_LOG_AGE:-30}"          # days
LOGFILE="${LOGFILE:-$HOME/logs/logrotate.log}"

# ----- Functions -----

rotate_logs() {
    local date_suffix
    date_suffix="$(date +'%Y%m%d')"

    for log_file in "$LOG_DIR"/*.log; do
        [ -f "$log_file" ] || continue

        if [ "$(stat -c%s "$log_file")" -gt "$MAX_LOG_SIZE" ]; then
            mv "$log_file" "$log_file.$date_suffix"
            gzip "$log_file.$date_suffix"
            echo "log rotated: $log_file" | tee -a "$LOGFILE"
        fi
    done
}

clean_old_logs() {
    find "$LOG_DIR" -name "*.gz" -mtime +"$MAX_LOG_AGE" -exec rm {} \;
    echo "old logs cleaned up" | tee -a "$LOGFILE"
}

# ----- Main -----

mkdir -p "$LOG_DIR" "$(dirname "$LOGFILE")"
rotate_logs
clean_old_logs
