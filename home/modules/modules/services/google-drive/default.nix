{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.modules.services.google-drive;
  remoteName = builtins.head (lib.splitString ":" cfg.remote);
  bootstrapScript = pkgs.writeText "google-drive-config-init.py" ''
    import configparser
    import os
    from pathlib import Path
    import subprocess
    import sys

    destination = Path(sys.argv[1])
    if destination.exists():
        print("Existing rclone config preserved; no credentials or tokens changed.")
        sys.exit(0)

    def credential(entry):
        value = subprocess.check_output([sys.argv[5], entry], text=True).strip()
        if not value or "\n" in value or "\r" in value:
            raise ValueError("Passage client credentials must be nonempty single-line values")
        return value

    parser = configparser.ConfigParser(interpolation=None)
    parser[sys.argv[2]] = {
        "type": "drive",
        "scope": "drive",
        "client_id": credential(sys.argv[3]),
        "client_secret": credential(sys.argv[4]),
    }
    destination.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    # Exclusive creation prevents replacing an existing config or OAuth token.
    with os.fdopen(os.open(destination, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "w") as output:
        parser.write(output)
    print("Created private rclone config. Complete OAuth with rclone config reconnect.")
  '';
  bootstrap = pkgs.writeShellApplication {
    name = "google-drive-config-init";
    runtimeInputs = [pkgs.git];
    text = ''
      export PASSAGE_AGE=${lib.getExe pkgs.rage}
      exec ${lib.getExe pkgs.python3} ${bootstrapScript} ${lib.escapeShellArgs [
        cfg.configFile
        remoteName
        cfg.passage.clientIdEntry
        cfg.passage.clientSecretEntry
        (lib.getExe pkgs.passage)
      ]}
    '';
  };
  authorized = pkgs.writeShellScript "google-drive-authorized" ''
    set -o pipefail
    ${lib.getExe cfg.package} config dump --config ${lib.escapeShellArg cfg.configFile} --ask-password=false |
      ${lib.getExe pkgs.jq} -e --arg remote ${lib.escapeShellArg remoteName} \
        '(.[$remote].token // "") | length > 0' >/dev/null
  '';
  mountArgs = [
    (lib.getExe cfg.package)
    "mount"
    cfg.remote
    cfg.mountPoint
    "--config"
    cfg.configFile
    "--cache-dir"
    cfg.cacheDirectory
    "--vfs-cache-mode"
    "full"
    "--vfs-cache-max-size"
    cfg.cacheMaxSize
    "--vfs-cache-max-age"
    "24h"
    "--vfs-write-back"
    "5s"
    "--dir-cache-time"
    "5m"
    "--poll-interval"
    "1m"
    "--umask"
    "077"
    "--log-level"
    "INFO"
  ];
in {
  options.modules.services.google-drive = {
    enable = mkEnableOption "private Google Drive mount using rclone (Linux)";
    package = lib.mkPackageOption pkgs "rclone" {};
    remote = mkOption {
      type = types.str;
      default = "google-drive:";
      description = "Configured rclone remote and optional subdirectory to mount";
    };
    passage = {
      enable = mkEnableOption "initializing client credentials from Passage without storing an OAuth token there";
      clientIdEntry = mkOption {
        type = types.str;
        default = "services/rclone/google-drive/client-id";
        description = "Passage entry holding the Google OAuth desktop client ID";
      };
      clientSecretEntry = mkOption {
        type = types.str;
        default = "services/rclone/google-drive/client-secret";
        description = "Passage entry holding the Google OAuth desktop client secret";
      };
    };
    mountPoint = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/GoogleDrive";
      description = "Empty directory at which to mount Google Drive";
    };
    configFile = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/rclone/rclone.conf";
      description = "Writable runtime rclone configuration containing OAuth tokens; never store credentials in Nix";
    };
    cacheDirectory = mkOption {
      type = types.str;
      default = "${config.xdg.cacheHome}/rclone-google-drive";
      description = "Private local VFS cache; may contain plaintext Drive files and pending uploads";
    };
    cacheMaxSize = mkOption {
      type = types.str;
      default = "5G";
      description = "Soft VFS cache limit; open files and pending uploads can exceed it";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isLinux;
        message = "modules.services.google-drive requires Linux with host FUSE support.";
      }
    ];

    home.packages = [cfg.package] ++ lib.optional cfg.passage.enable bootstrap;

    home.activation.google-drive-config = mkIf cfg.passage.enable (lib.hm.dag.entryAfter ["writeBoundary"] ''
      if ! run ${lib.getExe bootstrap}; then
        warnEcho "Google Drive config initialization failed. Check Passage and rerun google-drive-config-init."
      fi
    '');

    systemd.user.services.google-drive = {
      Unit = {
        Description = "Private Google Drive mount";
        # Authentication is interactive. A missing config must not break login.
        ConditionPathExists = cfg.configFile;
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "notify";
        Environment = ["PATH=/run/wrappers/bin:${lib.makeBinPath [pkgs.fuse3 pkgs.coreutils]}"];
        ExecStartPre = "${pkgs.writeShellScript "google-drive-prepare" ''
          umask 077
          ${lib.getExe' pkgs.coreutils "mkdir"} -p ${lib.escapeShellArgs [cfg.mountPoint cfg.cacheDirectory]}
        ''}";
        # Client credentials alone are not enough: wait for browser OAuth.
        ExecCondition = toString authorized;
        ExecStart = lib.escapeShellArgs mountArgs;
        # Use NixOS's privileged helper, not the unwrapped store binary.
        ExecStop = "/run/wrappers/bin/fusermount3 -u ${lib.escapeShellArg cfg.mountPoint}";
        Restart = "on-failure";
        RestartSec = 30;
        TimeoutStartSec = "2min";
        TimeoutStopSec = "2min";
        UMask = "0077";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
