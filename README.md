# devops_scripts

A collection of Bash automation scripts for common DevOps tasks: backups, log rotation, and system resource monitoring. Written and tested on Ubuntu.

## Scripts

### `backup.sh`
Backs up a local directory to a remote host over SSH using `rsync`. Logs success/failure with timestamps.

**Configuration** (environment variables, all optional):
| Variable | Default | Description |
|---|---|---|
| `SOURCE_DIR` | `~/backup_source/` | Directory to back up |
| `REMOTE_USER` | current user | SSH user on the remote host |
| `REMOTE_HOST` | `127.0.0.1` | Remote host to back up to |
| `REMOTE_DIR` | `~/backup_dest/` | Destination directory on the remote host |
| `LOG_FILE` | `~/logs/backup.log` | Where results are logged |

```bash
./backup.sh
# or with overrides:
SOURCE_DIR=/data REMOTE_HOST=192.168.1.10 ./backup.sh
```

### `logrotate.sh`
Rotates and compresses `.log` files in a directory once they exceed a size threshold, and deletes rotated logs older than a set age.

**Configuration:**
| Variable | Default | Description |
|---|---|---|
| `LOG_DIR` | `~/logs` | Directory containing logs to rotate |
| `MAX_LOG_SIZE` | `5000000` (5 MB) | Size threshold in bytes |
| `MAX_LOG_AGE` | `30` | Days to keep rotated logs before deletion |
| `LOGFILE` | `~/logs/logrotate.log` | Where results are logged |

### `system_monitor.sh`
Checks CPU, memory, and disk usage, and logs a warning if any exceed their threshold.

**Configuration:**
| Variable | Default | Description |
|---|---|---|
| `CPU_THRESHOLD` | `80` | CPU usage %% to trigger a warning |
| `MEM_THRESHOLD` | `85` | Memory usage %% to trigger a warning |
| `DISK_THRESHOLD` | `70` | Disk usage %% to trigger a warning |
| `LOG_FILE` | `~/logs/system_monitor.log` | Where results are logged |

## Running on a schedule

All three are designed to run via `cron`, e.g.:

​```
0 1 * * * /path/to/logrotate.sh
0 2 * * * /path/to/backup.sh
*/30 * * * * /path/to/system_monitor.sh
​```


## Author

Amir Ismail — built as part of ongoing DevOps skill-building.

