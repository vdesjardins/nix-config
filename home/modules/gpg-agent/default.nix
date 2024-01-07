{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.gpg-agent-custom;
in {
  options.services.gpg-agent-custom = {
    enable = mkEnableOption "gpg-agent";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf pkgs.hostPlatform.isLinux {
      home.packages = with pkgs; [gnupg pinentry-gtk2];

      services.gpg-agent = {
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
    })

    (mkIf pkgs.hostPlatform.isDarwin {
      home.packages = with pkgs; [gnupg pinentry_mac];

      home.file.".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 30
        max-cache-ttl 120
        default-cache-ttl-ssh 30
        max-cache-ttl-ssh 120
        ignore-cache-for-signing
        no-allow-external-cache
        enable-ssh-support
        log-file ${config.home.homeDirectory}/.gnupg/gpg-agent.log
      '';

      home.sessionVariables = {
        SSH_AUTH_SOCK = config.home.homeDirectory + "/.gnupg/S.gpg-agent.ssh";
      };

      programs.zsh.initExtra = ''
        gpgconf --launch gpg-agent >/dev/null
      '';
    })
  ]);
}
