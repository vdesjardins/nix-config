{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  agentSockPath = config.xdg.configHome + "/yubikey-agent/yubikey-agent.sock";
  cfg = config.modules.shell.tools.yubikey-agent;
in {
  options.modules.shell.tools.yubikey-agent = {
    enable = mkEnableOption "yubikey-agent";
  };

  config =
    mkIf cfg.enable
    (mkMerge [
      {
        home.sessionVariables = {
          SSH_AUTH_SOCK = agentSockPath;
        };
      }

      (mkIf pkgs.stdenv.hostPlatform.isLinux {
        home.packages = with pkgs; [yubikey-agent pinentry-gtk2];

        systemd.user.services.yubikey-agent = {
          Unit.Description = "Seamless ssh-agent for YubiKeys";
          Unit.Documentation = "https://filippo.io/yubikey-agent";

          Service = {
            IPAddressDeny = "any";
            RestrictAddressFamilies = "AF_UNIX";
            RestrictNamespaces = "yes";
            RestrictRealtime = "yes";
            RestrictSUIDSGID = "yes";
            LockPersonality = "yes";
            SystemCallFilter = "@system-service @privileged @resources";
            SystemCallErrorNumber = "EPERM";
            SystemCallArchitectures = "native";
            NoNewPrivileges = "yes";
            KeyringMode = "private";
            UMask = 0177;
            RuntimeDirectory = ".config/yubikey-agent";
            RuntimeDirectoryMode = 0700;
            Environment = "PATH=/home/vince/.nix-profile/bin";

            ExecReload = ["${pkgs.util-linux}/bin/kill -HUP $MAINPID"];

            ExecStart = ["${pkgs.yubikey-agent}/bin/yubikey-agent -l ${agentSockPath}"];
          };

          Install.WantedBy = ["default.target"];
        };
      })

      (mkIf pkgs.stdenv.hostPlatform.isDarwin {
        home.packages = with pkgs; [yubikey-agent pinentry_mac];

        launchd.agents.yubikey-agent = {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.yubikey-agent}/bin/yubikey-agent"
              "-l"
              agentSockPath
            ];
            KeepAlive = true;
          };
        };
      })
    ]);
}
