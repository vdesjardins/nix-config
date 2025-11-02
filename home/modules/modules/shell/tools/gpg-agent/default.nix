{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.gpg-agent;
in {
  options.modules.shell.tools.gpg-agent = {
    enable = mkEnableOption "gpg-agent";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = with pkgs; [gnupg gcr];

      services.gpg-agent = {
        inherit (cfg) enable;

        pinentry.package = pkgs.pinentry-gnome3;

        defaultCacheTtl = 30;
        maxCacheTtl = 120;
        defaultCacheTtlSsh = 30;
        maxCacheTtlSsh = 120;
        enableSshSupport = true;
        enableScDaemon = true;

        extraConfig = ''
          ignore-cache-for-signing
          no-allow-external-cache
        '';
      };

      wayland.windowManager.sway.config = {
        window.commands = [
          {
            criteria = {
              app_id = "^gcr-prompter$";
            };
            command = "floating enable, sticky enable, border pixel 1";
          }
        ];
      };
    })

    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home = {
        packages = with pkgs; [gnupg pinentry_mac];

        file.".gnupg/gpg-agent.conf".text = ''
          default-cache-ttl 30
          max-cache-ttl 120
          default-cache-ttl-ssh 30
          max-cache-ttl-ssh 120
          ignore-cache-for-signing
          no-allow-external-cache
          enable-ssh-support
          log-file ${config.home.homeDirectory}/.gnupg/gpg-agent.log
        '';

        sessionVariables = {
          SSH_AUTH_SOCK = config.home.homeDirectory + "/.gnupg/S.gpg-agent.ssh";
        };
      };

      programs.zsh.initContent = ''
        gpgconf --launch gpg-agent >/dev/null
      '';
    })
  ]);
}
