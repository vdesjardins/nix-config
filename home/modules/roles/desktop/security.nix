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
    modules.desktop.extensions.rofi-rbw.enable = true;
    home.packages = with pkgs; [bitwarden-desktop];
  };
}
