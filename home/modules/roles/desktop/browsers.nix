{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.browsers;
in {
  options.roles.desktop.browsers = {
    enable = mkEnableOption "desktop.browsers";
  };

  config = mkIf cfg.enable {
    modules.desktop = {
      browsers = {
        firefox = {
          enable = true;
          enablePolicies = true;
        };
        tridactyl.enable = true;
        bitwarden.enable = true;
      };
      tools = {
        buku.enable = true;
      };
      extensions = {
        rofi-buku.enable = pkgs.stdenv.isLinux;
      };
    };
  };
}
