{
  config,
  lib,
  pkgs,
  ...
}: let
  hostName = config.networking.hostName;
  credentialsDir = "/var/backups/bookmarks";
  snapshot = "/var/cache/restic-backups-bookmarks/sqlite/bookmarks.db";
  passageEntry = name: "hosts/${hostName}/backups/bookmarks/${name}";
in {
  services.restic.backups.bookmarks = {
    initialize = true;
    repository = "s3:s3.ca-east-006.backblazeb2.com/kube-backups-v/backups/bookmarks";
    user = "root";
    paths = [snapshot];

    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      RandomizedDelaySec = "0";
      Persistent = true;
    };

    # Match the other B2 backups: credentials are read from a private runtime
    # environment file, never embedded into the Nix store.
    passwordFile = "";
    environmentFile = "${credentialsDir}/env";

    backupPrepareCommand = ''
      set -euo pipefail
      umask 077
      mkdir -p ${builtins.dirOf snapshot}
      rm -f ${snapshot}
      ${lib.getExe pkgs.sqlite} -readonly /home/vince/.local/share/bookmarks/bookmarks.db \
        ".timeout 10000" ".backup '${snapshot}'"
      result="$(${lib.getExe pkgs.sqlite} -readonly ${snapshot} 'PRAGMA quick_check;')"
      if [ "$result" != ok ]; then
        echo "Bookmarks SQLite snapshot failed its integrity check" >&2
        exit 1
      fi
    '';

    backupCleanupCommand = ''
      rm -f ${snapshot}
    '';

    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];
  };

  system.activationScripts.backups-bookmarks.text = ''
    (
      set -euo pipefail
      umask 077
      mkdir -p ${credentialsDir}
      chmod 700 ${credentialsDir}

      # These secrets belong to vince's Passage store, not root's.
      read_secret() {
        ${lib.getExe' pkgs.util-linux "runuser"} -u vince -- \
          ${lib.getExe' pkgs.coreutils "env"} HOME=/home/vince PASSAGE_AGE=${lib.getExe pkgs.rage} \
          ${lib.getExe pkgs.passage} "$1"
      }
      key_id="$(read_secret ${lib.escapeShellArg (passageEntry "b2.key-id")})"
      key="$(read_secret ${lib.escapeShellArg (passageEntry "b2.key")})"
      password="$(read_secret ${lib.escapeShellArg (passageEntry "restic")})"

      # All three are single-line credentials; reject unsafe EnvironmentFile
      # syntax rather than writing a truncated or injectable value.
      for value in "$key_id" "$key" "$password"; do
        if [[ ! "$value" =~ ^[A-Za-z0-9_+/=-]+$ ]]; then
          echo "Invalid or empty bookmarks backup credential in Passage" >&2
          exit 1
        fi
      done

      temporary="$(mktemp ${credentialsDir}/env.XXXXXX)"
      trap 'rm -f "$temporary"' EXIT
      printf '%s\n' \
        "AWS_ACCESS_KEY_ID=$key_id" \
        "AWS_SECRET_ACCESS_KEY=$key" \
        "RESTIC_PASSWORD=$password" > "$temporary"
      chmod 600 "$temporary"
      mv -f "$temporary" ${credentialsDir}/env
    )
  '';
}
