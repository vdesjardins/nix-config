{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.gtk;
in {
  options.roles.desktop.gtk = {
    enable = mkEnableOption "desktop.gtk";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
