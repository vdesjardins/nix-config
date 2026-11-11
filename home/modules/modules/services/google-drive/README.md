# Google Drive mount

Enable with `modules.services.google-drive.enable = true`. This Linux-only
module is enabled explicitly for `vince` on host `v`, not through a shared role.
NixOS must provide `programs.fuse.enable = true`. Neither `--allow-other` nor
`programs.fuse.userAllowOther` is needed: the mount belongs to the user only.

## One-time authentication

Create your own Google OAuth **Desktop app** client and enable the Google Drive
API in that project. rclone's shared client is being retired during 2026.
For an external personal app, Testing refresh tokens generally expire after
seven days; publishing the consent app to Production avoids that testing limit.

For `vince` on `v`, Passage bootstrap is enabled. Store **only** the client
credentials (each entry must contain a single line), never the OAuth token:

```bash
passage insert services/rclone/google-drive/client-id
passage insert services/rclone/google-drive/client-secret
```

Home Manager activation runs `google-drive-config-init`. You can also run it
manually after adding the secrets. It creates a private mode-0600 config with
the `google-drive` remote and full Drive scope only when the entire config
file is absent. Existing configs and tokens are never replaced. Missing Passage
entries warn without blocking activation. If you have another existing rclone
config, add the remote and client credentials using `rclone config` instead;
the bootstrap intentionally does not merge into it.

Complete OAuth as `vince` (never with sudo):

```bash
google-drive-config-init
rclone config reconnect google-drive: --config "$HOME/.config/rclone/rclone.conf"
```

Allow browser authentication and select the intended Google account. The token
is saved only in the local writable config and refreshed by rclone. The mount
skips startup until the remote has a token. Do not select a Shared Drive unless
that is what you intend to mount.

Without Passage bootstrap, use `rclone config` to create the remote manually.

Then:

```bash
chmod 600 "$HOME/.config/rclone/rclone.conf"
rclone lsd google-drive:
systemctl --user start google-drive
ls "$HOME/GoogleDrive"
```

The service starts automatically at subsequent logins. If no config exists,
it skips startup until you authenticate and start it manually. Configs without
a token for the named remote are also skipped. Network/startup failures retry
every 30 seconds.
No OAuth login or Drive access takes place during Nix builds or activation.

## Behavior and safety

- The mount is **read-write**: deletes, moves, and edits affect Google Drive.
- Files download on demand; this is not a full offline synchronization service.
- The private full VFS cache defaults to a **5 GiB soft limit** and 24-hour max
  age. Open files and pending uploads may exceed these limits. Cached content is
  plaintext on local storage, subject to any underlying disk encryption.
- Writes upload after files close and a five-second write-back delay. Wait for
  uploads to finish before logging out or shutting down. The user service does
  not promise to finish pending uploads after logout. Never delete the cache
  while it contains pending uploads.
- Google Docs/Sheets/Slides appear using rclone's export formats. Editing an
  exported file is not equivalent to editing the original native Google doc.
- Keep the runtime config private and writable: rclone refreshes OAuth tokens.
  Do not put it or its tokens in the repository or Nix store.
- Use a dedicated, empty mount directory. Do not enable `--allow-non-empty`.

Troubleshoot with:

```bash
systemctl --user status google-drive
journalctl --user -u google-drive -n 50
```

Stop/unmount with `systemctl --user stop google-drive`. If files are busy,
close applications using the mount and retry; avoid forced/lazy unmounts.

Options expose the rclone package, remote, mount point, runtime config path,
cache directory, and cache size. If overriding `configFile`, also supply that
path to the interactive `rclone config` command.
