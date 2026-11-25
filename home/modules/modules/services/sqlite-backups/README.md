# User SQLite backups

Enabled for `vince@v` in `home/users/vince-v.nix`. Both databases use Home
Manager's Restic user services, with daily persistent timers at 02:00.
The host only enables `users.users.vince.linger` so the user manager runs
while logged out. The machine must still be awake and online.

## Credentials and monitoring

Existing Passage entries remain under `hosts/v/backups/<bookmarks|repwise>/`:

- `b2.key-id`
- `b2.key`
- `restic`
- `healthchecks-url` (base HTTPS ping URL, without `/start` or `/fail`)

Home Manager activation writes B2 credentials and ping URLs into private files
under `~/.config/restic-backups/`. Restic reads the repository password from
Passage at runtime. Credentials are never embedded in the Nix store.

Healthchecks receives start and completion pings; systemd's `SERVICE_RESULT`
determines success or failure, including backup, retention, and repository-check
failures. Ping failures are logged but do not fail the backup. Configure each
Healthchecks check for 02:00 in the host's timezone, with a suitable grace period
and notification channel. Missed pings cover jobs that never start.

## Migration and operation

Apply the host configuration first to remove the root timers and enable
lingering, then apply Home Manager to install the user timers and credentials.
Do not leave both sets of timers enabled.

B2 repositories, encryption passwords, Passage paths, and retention policies are
unchanged. New snapshots contain files under
`~/.cache/restic-backups-<name>/sqlite/` rather than `/var/cache/`. Older snapshots
remain available at their original paths; Restic groups retention by host and
paths, so those older groups are retained separately.

```sh
systemctl --user start restic-backups-repwise.service
systemctl --user start restic-backups-bookmarks.service
systemctl --user list-timers 'restic-backups-*'
journalctl --user -u restic-backups-repwise.service
restic-repwise snapshots
restic-bookmarks snapshots
```

The wrappers no longer require `sudo`. Root-owned credentials and caches under
`/var/backups/` and `/var/cache/restic-backups-*` are not automatically deleted.
