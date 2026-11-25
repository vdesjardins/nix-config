{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.sqlite-backups;
  names = ["bookmarks" "repwise"];
  database = name:
    if name == "repwise"
    then "training.db"
    else "bookmarks.db";
  credentialsDir = name: "${config.xdg.configHome}/restic-backups/${name}";
  snapshot = name: "${config.xdg.cacheHome}/restic-backups-${name}/sqlite/${database name}";
  passageEntry = name: key: "${cfg.passagePrefix}/${name}/${key}";
  ping = name: suffix:
    pkgs.writeShellScript "${name}-healthchecks-ping" ''
      if ! { printf 'url = "%s%s"\n' "$(< ${lib.escapeShellArg "${credentialsDir name}/healthchecks-url"})" "${suffix}" |
        ${lib.getExe pkgs.curl} --config - --proto '=https' --silent --fail \
          --output /dev/null --connect-timeout 5 --max-time 15; }; then
        echo "Healthchecks ping failed for ${name}" >&2
      fi
    '';
in {
  options.modules.services.sqlite-backups = {
    enable = lib.mkEnableOption "nightly SQLite backups to B2 with Healthchecks monitoring";
    passagePrefix = lib.mkOption {
      type = lib.types.str;
      description = "Passage prefix containing per-database backup credentials and Healthchecks URLs.";
      example = "hosts/v/backups";
    };
    repositoryPrefix = lib.mkOption {
      type = lib.types.str;
      description = "Restic B2 repository prefix, with a separate repository for each database.";
      example = "s3:s3.ca-east-006.backblazeb2.com/kube-backups-v/backups";
    };
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
    services.restic = {
      enable = true;
      backups = lib.genAttrs names (name: {
        initialize = true;
        repository = "${cfg.repositoryPrefix}/${name}";
        paths = [(snapshot name)];
        passwordCommand = "${lib.getExe' pkgs.coreutils "env"} PASSAGE_AGE=${lib.getExe pkgs.rage} ${lib.getExe pkgs.passage} ${passageEntry name "restic"}";
        environmentFile = "${credentialsDir name}/env";
        timerConfig = {
          OnCalendar = "*-*-* 02:00:00";
          RandomizedDelaySec = "0";
          Persistent = true;
        };
        backupPrepareCommand = ''
          set -euo pipefail
          ${ping name "/start"}
          umask 077
          mkdir -p ${lib.escapeShellArg (builtins.dirOf (snapshot name))}
          rm -f ${lib.escapeShellArg (snapshot name)}
          ${lib.getExe pkgs.sqlite} -readonly ${lib.escapeShellArg "${config.xdg.dataHome}/${name}/${database name}"} \
            ".timeout 10000" ${lib.escapeShellArg ".backup '${snapshot name}'"}
          result="$(${lib.getExe pkgs.sqlite} -readonly ${lib.escapeShellArg (snapshot name)} 'PRAGMA quick_check;')"
          if [ "$result" != ok ]; then
            echo "${name} SQLite snapshot failed its integrity check" >&2
            exit 1
          fi
        '';
        backupCleanupCommand = ''
          set -euo pipefail
          rm -f ${lib.escapeShellArg (snapshot name)}
          if [ "$SERVICE_RESULT" = success ]; then
            ${ping name ""}
          else
            ${ping name "/fail"}
          fi
        '';
        pruneOpts = ["--keep-daily 3" "--keep-weekly 3" "--keep-monthly 3"];
      });
    };

    home.activation.sqlite-backup-credentials = lib.hm.dag.entryBetween ["reloadSystemd"] ["writeBoundary"] (
      lib.concatMapStringsSep "\n" (name: ''
        (
          set -euo pipefail
          umask 077
          directory=${lib.escapeShellArg (credentialsDir name)}
          mkdir -p "$directory"
          chmod 700 "$directory"
          read_secret() {
            PASSAGE_AGE=${lib.getExe pkgs.rage} ${lib.getExe pkgs.passage} "$1"
          }
          key_id="$(read_secret ${lib.escapeShellArg (passageEntry name "b2.key-id")})"
          key="$(read_secret ${lib.escapeShellArg (passageEntry name "b2.key")})"
          url="$(read_secret ${lib.escapeShellArg (passageEntry name "healthchecks-url")})"
          for value in "$key_id" "$key"; do
            if [[ ! "$value" =~ ^[A-Za-z0-9_+/=-]+$ ]]; then
              echo "Invalid or empty ${name} backup credential in Passage" >&2
              exit 1
            fi
          done
          if [[ ! "$url" =~ ^https://[A-Za-z0-9.-]+(/[A-Za-z0-9_-]+)+$ ]]; then
            echo "Invalid Healthchecks URL for ${name}" >&2
            exit 1
          fi
          temporary="$(mktemp "$directory/env.XXXXXX")"
          trap 'rm -f "$temporary"' EXIT
          printf '%s\n' "AWS_ACCESS_KEY_ID=$key_id" "AWS_SECRET_ACCESS_KEY=$key" > "$temporary"
          chmod 600 "$temporary"
          mv -f "$temporary" "$directory/env"
          temporary="$(mktemp "$directory/healthchecks-url.XXXXXX")"
          printf '%s\n' "$url" > "$temporary"
          chmod 600 "$temporary"
          mv -f "$temporary" "$directory/healthchecks-url"
        )
      '')
      names
    );
  };
}
