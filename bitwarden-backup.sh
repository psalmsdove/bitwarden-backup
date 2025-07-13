#!/bin/bash

# Bitwarden Backup Script
# Backs up Bitwarden vault as JSON to a specified local directory.

# ======= CONFIGURATION =======
# Don't put your password here for security: use environment variables or secret injection!
BW_EMAIL="${BW_EMAIL:?You must set the BW_EMAIL environment variable.}"
BW_PASSWORD="${BW_PASSWORD:?You must set the BW_PASSWORD environment variable.}"
BACKUP_DIR="${BW_BACKUP_DIR:-$HOME/bitwarden-backups}"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Timestamp for versioned backup files
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/bitwarden-backup-$DATE.json"

# ======= BITWARDEN LOGIN AND BACKUP =======
# Get Bitwarden CLI session key
BW_SESSION=$(bw login "$BW_EMAIL" "$BW_PASSWORD" --raw)

if [ -z "$BW_SESSION" ]; then
    echo "Bitwarden login failed. Aborting."
    exit 1
fi

# Unlock the vault (if necessary) - optional:
# bw unlock --password "$BW_PASSWORD" --raw > /dev/null

# Export vault as (unencrypted!) JSON
bw export --session "$BW_SESSION" --format json > "$BACKUP_FILE"

# Logout (clean up session)
bw logout --session "$BW_SESSION"

# Optional: Restrict file permissions
chmod 600 "$BACKUP_FILE"

echo "✅ Bitwarden vault backup completed: $BACKUP_FILE"
