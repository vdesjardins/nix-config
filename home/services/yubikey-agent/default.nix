{
  config,
  lib,
  pkgs,
  ...
}: let
  agentSockPath = config.xdg.configHome + "/yubikey-agent/yubikey-agent.sock";
in
  with lib;
    mkMerge [
      {
        home.packages = with pkgs; [yubikey-agent pinentry_gtk2];

        home.sessionVariables = {
          SSH_AUTH_SOCK = agentSockPath;
        };
      }

      (mkIf pkgs.hostPlatform.isLinux {
        systemd.user.services.yubikey-agent = {
          Unit.Description = "Seamless ssh-agent for YubiKeys";
          Unit.Documentation = "https://filippo.io/yubikey-agent";

          Service = {
            IpAddressDeny = "any";
            RestrictAddressFamilies = "AF_UNIX";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            LockPersonality = true;
            SystemCallFilter = "@system-service @privileged @resources";
            SystemCallErrorNumber = "EPERM";
            SystemCallArchitectures = "native";
            NoNewPrivileges = true;
            KeyringMode = "private";
            UMask = 0177;
            RuntimeDirectory = "yubikey-agent";

            ExecReload = escapceShellArgs [
              "${pkgs.kill}/bin/kill"
              "-HUP"
              "$MAINPID"
            ];

            ExecStart = escapeShellArgs [
              "${pkgs.yubikey-agent}/bin/yubikey-agent"
              "-l"
              agentSockPath
            ];
          };

          Install.WantedBy = ["default.target"];
        };
      })

      (mkIf pkgs.hostPlatform.isDarwin {
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
    ]
