{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.extensions;
in {
  options.roles.desktop.extensions = {
    enable = mkEnableOption "desktop.extensions";
  };

  config = mkIf cfg.enable {
    roles.desktop.gtk.enable = true;
    roles.desktop.qt.enable = true;

    modules.desktop.extensions = {
      dconf.enable = true;
      dunst.enable = true;
      waybar.enable = true;
      rofi.enable = true;
      swaylock.enable = true;
      xdg-portal.enable = true;
    };

    services.cliphist.enable = true;
  };
}
