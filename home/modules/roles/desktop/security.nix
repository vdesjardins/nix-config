{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.security;
in {
  options.roles.desktop.security = {
    enable = mkEnableOption "desktop.security";
  };

  config = mkIf cfg.enable {
    # Enable security modules
    modules = {
      desktop = {
        tools.keepassxc = {
          enable = true;
          git.remoteUrl = "git@github.com:vdesjardins/keepassxc-vault.git";
        };
        messaging.fluffychat.enable = true;
        extensions.rofi-rbw.enable = true;
      };
    };

    home.packages = with pkgs; [bitwarden-desktop];
  };
}
