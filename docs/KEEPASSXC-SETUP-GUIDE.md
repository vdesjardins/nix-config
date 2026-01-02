# KeePassXC Integration Setup Guide

This guide walks through the complete setup of KeePassXC with D-Bus Secret
Service, YubiKey challenge-response, git versioning, and Syncthing sync.

## Prerequisites

- ✅ GitHub private repo created:
  `git@github.com:vdesjardins/keepassxc-vault.git`
- ✅ YubiKeys available
- ✅ Syncthing installed and running
- ✅ SSH key on this machine authorized for GitHub

## Step-by-Step Setup

### Phase 1: YubiKey Configuration (One-time per YubiKey)

#### 1.1 Check Current YubiKey Slot Status

Plug in your first YubiKey, then check its current configuration:

```bash
sudo ykman otp info
```

Output will show:

```text
Slot 1: [Configured/Empty]
Slot 2: [Configured/Empty]
```

Note which slots are available. The standard setup uses **Slot 2** for
challenge-response.

**Note:** You may need to use `sudo` to access the YubiKey, depending on your
system's udev rules configuration.

#### 1.2 Configure Each YubiKey with Same Secret

Generate a secure random secret (you'll use the same secret for all YubiKeys):

```bash
SECRET=$(od -An -tx1 -N20 /dev/urandom | tr -d ' ')
echo "Your secret: $SECRET"
```

For EACH YubiKey, run:

```bash
sudo ykman otp chalresp 2 "$SECRET" --force
```

Verify the configuration was successful:

```bash
sudo ykman otp info
```

Both Slot 1 and Slot 2 should now show "programmed".

Test the challenge-response (requires hex input):

```bash
sudo ykman otp calculate 2 74657374
```

This should output a 40-character hex string (response to challenge "test").

**Important:** Use the SAME secret on all YubiKeys so any key can unlock the
database. Keep the secret value safe - you'll need it if you add more YubiKeys
later.

---

### Phase 2: Initialize KeePassXC Database

#### 2.1 Create Database Directory

```bash
mkdir -p ~/.local/share/keepassxc
cd ~/.local/share/keepassxc
```

#### 2.2 Create KeePassXC Database

1. Open KeePassXC (or run: `keepassxc`)
2. File → New Database
3. Set a **strong master password** (this is your primary defense)
4. Save as: `~/.local/share/keepassxc/database.kdbx`
5. Go to: Database → Database Security
6. Under "Challenge-Response":
   - Check: "Enable challenge-response authentication"
   - Choose: YubiKey (Slot 2 - HMAC-SHA1)
   - Click: "Test" (should succeed)
7. Save database
8. Test unlock with each YubiKey to ensure they all work

#### 2.3 Initialize Git Repository

```bash
cd ~/.local/share/keepassxc

# Initialize local git repo
git init

# Add GitHub remote
git remote add origin git@github.com:vdesjardins/keepassxc-vault.git

# Verify git can access GitHub (this will test SSH keys)
git remote -v

# Stage and commit initial database
git add database.kdbx
git commit -m "Initial KeePassXC database with YubiKey challenge-response"

# Push to GitHub
git push -u origin main

# Verify it worked
git log
```

If `git push` fails:

- Check SSH key: `ssh -T git@github.com`
- Ensure public key is added to GitHub
- Try: `ssh-add ~/.ssh/id_ed25519` (or your key path)

---

### Phase 3: Configure Syncthing

#### 3.1 Add Folder to Syncthing

In Syncthing web interface (default: <http://localhost:8384>):

1. Click: **Add Folder**
2. Set:
   - **Folder Path**: `~/.local/share/keepassxc/`
   - **Folder Label**: `keepassxc-db` (or similar)
   - **Folder ID**: `keepassxc-db`
3. Click: **Save**

#### 3.2 Configure Ignore Patterns

1. Go to: Folder → **Edit**
2. Tab: **Advanced**
3. **Ignore Patterns** section, add:

   ```text
   (?d)keepassxc.ini
   (?d).config/**
   (?d).cache/**
   (?d)tmp/**
   ```

4. Save

These patterns prevent per-machine settings from syncing (window size,
recent files, etc.).

#### 3.3 Add Other Machines

For each machine that should sync:

1. In Syncthing, add device (get device ID)
2. Share the keepassxc-db folder with that device
3. Accept the folder share on the other machine
4. Ensure SSH key for GitHub is available on other machines

---

### Phase 4: Deploy with home-manager

#### 4.1 Update Home-Manager Configuration

The security role is already configured. Just enable it in your user config:

For `home/users/vince-falcon.nix` (or your user file):

```nix
{
  roles.desktop.security.enable = true;
  # ... rest of your config
}
```

#### 4.2 Apply Configuration

```bash
cd /home/vince/projects/nix-config

# Build and check for errors
home-manager switch

# Verify modules loaded
systemctl --user status keepassxc
```

If there are errors, check:

- `~/.local/share/nix/profiles/home-manager/` for symlinks
- `journalctl --user -u keepassxc` for daemon logs
- `nix flake check` for config errors

#### 4.3 Verify D-Bus Service

```bash
# List D-Bus services (should show keepassxc)
dbus-send --print-reply \
  --dest=org.freedesktop.DBus \
  /org/freedesktop/DBus \
  org.freedesktop.DBus.ListNames | grep -i keepass

# Check if D-Bus Secret Service is available
busctl --user introspect \
  org.freedesktop.secrets \
  /org/freedesktop/secrets \
  org.freedesktop.Secret.Service
```

---

### Phase 5: Test Fluffychat Integration

#### 5.1 Open Fluffychat

```bash
fluffychat &
```

#### 5.2 Sign In

1. Create account or sign in
2. Enter username/password

#### 5.3 Check Credential Storage

1. Edit any account details
2. Observe: Fluffychat offers to save credential via Secret Service
3. If prompted to unlock KeePassXC: **Master password + insert YubiKey**
4. Credentials saved to KeePassXC

#### 5.4 Test Auto-Fill

1. Log out of Fluffychat
2. Reopen Fluffychat
3. Username field: Should be auto-filled
4. Password field: Can request from KeePassXC

---

### Phase 6: Verify Auto-Commit

#### 6.1 Monitor Git Commits

```bash
cd ~/.local/share/keepassxc

# Watch git log in real-time
watch -n 5 'git log --oneline -5'
```

#### 6.2 Make a Database Change

1. Open KeePassXC
2. Unlock with master password + YubiKey
3. Add a new entry or edit existing
4. Save

#### 6.3 Check Git History

Within 90 seconds, you should see:

```bash
git log --oneline -1
# Output: abc1234 Auto-backup: KeePassXC database update
```

If not appearing:

```bash
# Check systemd timer status
systemctl --user status keepassxc-auto-commit.path
systemctl --user status keepassxc-auto-commit.service

# Check logs
journalctl --user -u keepassxc-auto-commit.service
```

---

### Phase 7: Verify Auto-Lock

#### 7.1 Test Screen Lock

```bash
# Lock screen (varies by desktop environment)
# For GNOME: Ctrl+Alt+L
# For KDE: Ctrl+Alt+L
# For Sway: swaylock

# Verify database is locked
ps aux | grep keepassxc
# KeePassXC should still be running but database should be locked
```

#### 7.2 Test Idle Timeout

```bash
# Open KeePassXC
# Let it sit idle for 5 minutes
# Database should automatically lock
```

#### 7.3 Unlock After Lock

```bash
# Click anywhere in KeePassXC
# Master password + YubiKey prompt appears
# Enter master password and insert YubiKey
```

---

### Phase 8: Cross-Machine Sync

#### 8.1 On Second Machine

1. Add SSH key for GitHub (or use ssh-agent)
2. Add KeePassXC folder to Syncthing with same ID
3. Syncthing will download database
4. Run: `home-manager switch` (should apply same config)
5. systemd service starts automatically

#### 8.2 Test Sync

1. Add new entry on Machine A
2. Wait for Syncthing to sync (usually <30s)
3. On Machine B, KeePassXC reloads automatically (or manual File → Open Recent)
4. New entry visible on Machine B

#### 8.3 Handle Conflicts

If Syncthing detects conflict (rare, but possible):

- Syncthing saves conflicting version in `.stversions/`
- Keep the newer version (Syncthing default is "newest wins")
- Check git log if need full history: `cd ~/.local/share/keepassxc && git log`

---

## Troubleshooting

### Problem: Git Push Fails

```bash
# Check SSH connection
ssh -T git@github.com

# Add key to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Retry
cd ~/.local/share/keepassxc
git push
```

### Problem: D-Bus Secret Service Not Found

```bash
# Ensure KeePassXC is running
systemctl --user start keepassxc

# Check if service is available
busctl --user list | grep -i keepass

# Check systemd service status
systemctl --user status keepassxc
journalctl --user -u keepassxc -n 50
```

### Problem: YubiKey Not Recognized

```bash
# Check YubiKey is detected
ykman list

# Ensure correct slot configured (may need sudo)
sudo ykman otp info

# Test slot with sudo
sudo ykman otp calculate 2 74657374
```

If `ykman list` works but `ykman otp` commands fail:

- Try with `sudo`: `sudo ykman otp info`
- This is normal on many systems due to USB device permissions
- If you prefer to avoid `sudo`, you can configure udev rules to allow
  non-root access

### Problem: ykman OTP Commands Require sudo

If `ykman otp info` fails with "Failed to connect to YubiKey" but `ykman list`
works:

```bash
# Try with sudo
sudo ykman otp info

# If it works with sudo, your system requires elevated privileges
# Use sudo for all ykman otp commands in Phase 1:
sudo ykman otp chalresp 2 "$SECRET" --force
```

To avoid using sudo every time, add udev rules (optional):

```bash
# Create a udev rule for YubiKey OTP access
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="1050", \
MODE="0666"' | sudo tee /etc/udev/rules.d/99-yubikey.rules

# Reload udev rules
sudo udevadm control --reload

# Unplug and replug YubiKey
```

After adding udev rules, `ykman otp` commands should work without sudo.

## Test slot

ykman otp calculate 2 test

## Should output a code

```text

### Problem: Auto-Commit Not Working

```

```bash
# Check path unit
systemctl --user status keepassxc-auto-commit.path

# Check service
systemctl --user status keepassxc-auto-commit.service

# Check logs
journalctl --user -u keepassxc-auto-commit.service -n 50

# Manually trigger
cd ~/.local/share/keepassxc
touch database.kdbx  # Simulate modification
# Wait 60 seconds
git log --oneline -1  # Should show new commit
```

## Problem: Syncthing Not Syncing

```bash
# Check folder configuration
# Web UI: http://localhost:8384 → Folder status

# Verify directory exists
ls -la ~/.local/share/keepassxc/

# Check permissions
stat ~/.local/share/keepassxc/

# Check Syncthing logs
journalctl -u syncthing -n 50
```

---

## Maintenance

### Regular Backup

```bash
# Git provides version history (30+ days)
cd ~/.local/share/keepassxc
git log --oneline | head -20

# Export backup
git bundle create ~/keepassxc-backup.bundle --all
```

### Password Changes

```bash
# Change master password
# In KeePassXC: Database → Database Security → Master Key

# Change YubiKey challenge
# Configure new YubiKey with same secret (see Phase 1)
# Update database if using different slot
```

### Migrate to New Machine

```bash
# On new machine:
mkdir -p ~/.local/share/keepassxc
cd ~/.local/share/keepassxc

# Clone from GitHub
git clone git@github.com:vdesjardins/keepassxc-vault.git .

# Or sync via Syncthing (recommended)

# Enable in home-manager
# Run: home-manager switch

# Unlock with master password + YubiKey
```

---

## Security Notes

1. **Master Password**: Your primary defense. Use a strong, memorable password.
2. **YubiKey**: Physical possession required to unlock. Keep safe.
3. **GitHub Repo**: Private repo, encrypted at rest by GitHub.
4. **Git Credentials**: Use SSH key (not HTTPS password).
5. **Syncthing**: Over TLS, trusted devices only.
6. **Database File**: ~5MB, changes tracked in git, synced via Syncthing.

---

## Additional Resources

- KeePassXC Documentation: <https://keepassxc.org/docs/>
- YubiKey Challenge-Response:
  <https://docs.yubico.com/yesecurity/desktopp/otp_modes.html>
- D-Bus Secret Service:
  <https://specifications.freedesktop.org/secret-service/>
- Element-Desktop: <https://element.io/>

---

Last Updated: 2026-01-02
