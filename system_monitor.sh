

#!/bin/bash
#
# system_monitor.sh - Checks CPU, memory, and disk usage against
# configurable thresholds and logs a warning when any is exceeded.
#
# Configuration is done via environment variables, with sensible defaults
# below. Example override:
#   CPU_THRESHOLD=90 MEM_THRESHOLD=90 ./system_monitor.sh
#

set -uo pipefail

# ----- Configuration (override via environment variables) -----
CPU_THRESHOLD="${CPU_THRESHOLD:-80}"
MEM_THRESHOLD="${MEM_THRESHOLD:-85}"
DISK_THRESHOLD="${DISK_THRESHOLD:-70}"
LOG_FILE="${LOG_FILE:-$HOME/logs/system_monitor.log}"

# ----- Functions -----

check_cpu_usage() {
    local cpu_usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "high cpu usage: $cpu_usage%" | tee -a "$LOG_FILE"
    fi
}

check_memory_usage() {
    local mem_usage
    mem_usage=$(free | grep "Mem" | awk '{print $3/$2 * 100}')

    if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
        echo "high memory usage: $mem_usage%" | tee -a "$LOG_FILE"
    fi
}

check_disk_usage() {
    local disk_usage
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        echo "high disk usage: $disk_usage%" | tee -a "$LOG_FILE"
    fi
}

# ----- Main -----

mkdir -p "$(dirname "$LOG_FILE")"
check_cpu_usage
check_memory_usage
check_disk_usage
