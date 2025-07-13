# 🛡️ Bitwarden CLI Vault Backup Automation

A simple Bash script to automatically back up your Bitwarden vault to your local machine.
Supports both standard login and 2FA (two-factor authentication) setups by using secure session tokens for automation.

## 📋 Features

- Exports your Bitwarden vault to encrypted or plain JSON for offline access
- Fully compatible with Bitwarden accounts using 2FA
- Designed for safe, non-interactive, scheduled (cron) use
- Timestamped, versioned backups
- Secure credential handling (via environment variables & session token files)

## ⚡️ Requirements

- Linux/macOS machine with Bash
- Bitwarden CLI (latest release downloads here)
- Bitwarden account (with or without 2FA enabled)
    
 
## 🚀 Installation
#### 1. Download Bitwarden CLI

**Do NOT use npm for CLI installation; download the official static binary:**
```
# Replace with the latest URL from releases page above

cd ~/Downloads

wget https://github.com/bitwarden/clients/releases/download/cli-v2024.4.0/bw-linux-2024.4.0.zip

unzip bw-linux-*.zip

sudo mv bw /usr/local/bin/

sudo chmod +x /usr/local/bin/bw
```

Test with:
```
bw --version
```

## ⚙️ Usage
### A. Standard Login (No 2FA)


    Set your credentials via environment variables (for security).
    Never commit your password!

    
```
export BW_EMAIL="your@email.com"

export BW_PASSWORD="your-password"
```
Run the script manually to test:
```
./bitwarden-backup.sh
```
The script will log in, export your vault, and save a timestamped JSON in your backup folder.

### B. 2FA (Two-Factor Authentication) Setup

> Bitwarden CLI **automation cannot input a 2FA code interactively for cron jobs.** Solution: Use a long-lived session token.

**How to Get and Use Your Session Token**

####    1. Perform a one-time login manually:

```
bw login

# Enter your email and master password

# You’ll be prompted for your 2FA code (from app/email/etc)
```

#### 2. Unlock and retrieve the session token:

```
bw unlock --raw

# Enter your master password one more time

# Copy the session token output, it'll look like: eyJhbGciOi...
```

#### 3. Save the session token safely (e.g., ~/bitwarden-session.txt):

```
echo "YOUR_SESSION_TOKEN" > ~/bitwarden-session.txt

chmod 600 ~/bitwarden-session.txt
```
#### 4. Edit the script so it reads this session token:

```
# Example (inside bitwarden-backup.sh)
BW_SESSION=$(cat ~/bitwarden-session.txt)
```
You now have a ready-to-automate environment that does not require 2FA input every time!

> Note: If your session expires (e.g. after logging out everywhere or after some weeks), simply repeat the unlock process and update your session file.

# ⏰ Automate Backups with Cron

To schedule an automatic backup every night at 23:00:

### Open your crontab:

```
crontab -e
```
### Add this line (replace /path/to/bitwarden-backup.sh with your actual path):

```
    0 23 * * * /path/to/bitwarden-backup.sh >> /path/to/bitwarden-backup.log 2>&1
```

Tip:

- If using session token, ensure the backup script has read access to the session file.
- If using env vars, you must also export them within your crontab or source them in the script.

# 🔒 Security Tips

- Do not expose your Bitwarden session token, email, or master password.
- Backups are plaintext JSON: Consider GPG encrypting your backup files:
    
```
gpg -c "$BACKUP_FILE" && rm "$BACKUP_FILE"
```

- Regularly clean/rotate session tokens if you change your master password or when you log out of Bitwarden everywhere.
- Always set permissions to restrict access to your backup folder and files:
  
```
chmod 700 ~/bitwarden-backups

chmod 600 ~/bitwarden-backups/*
```

# 📚 Further Reading

- [Bitwarden CLI Docs](https://bitwarden.com/help/cli/)
- [Bitwarden CLI Releases](https://github.com/bitwarden/clients/releases/tag/web-v2025.7.0)
- [Bitwarden Security FAQ](https://bitwarden.com/help/security-faq/)
