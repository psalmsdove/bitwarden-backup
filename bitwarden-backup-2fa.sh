#!/bin/bash

BW_SESSION=$(cat /path/to/session_token.txt)
BACKUP_DIR="$HOME/bitwarden-backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/bitwarden-backup-$DATE.json"

bw export --session "$BW_SESSION" --format json > "$BACKUP_FILE"
chmod 600 "$BACKUP_FILE"

echo "Backup completed: $BACKUP_FILE"
