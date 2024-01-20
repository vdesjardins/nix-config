{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.extensions.xdg-portal;
in {
  options.modules.desktop.extensions.xdg-portal = {
    enable = mkEnableOption "xdg-portal";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      inherit (cfg) enable;

      config.common.default = ["wlr" "gtk"];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
