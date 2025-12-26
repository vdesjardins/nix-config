{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) str package;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.gtk;
in {
  options.roles.desktop.gtk = {
    enable = mkEnableOption "desktop.gtk";

    font = mkOption {
      type = str;
    };

    themePackage = mkOption {
      type = package;
    };
    themeName = mkOption {
      type = str;
    };

    colorScheme = mkOption {
      type = str;
      default = "prefer-dark";
    };

    iconPackage = mkOption {
      type = package;
      default = pkgs.papirus-icon-theme;
    };

    iconName = mkOption {
      type = str;
      default = "Papirus-Dark";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      inherit (cfg) colorScheme;

      iconTheme = {
        package = cfg.iconPackage;
        name = cfg.iconName;
      };

      theme = {
        package = cfg.themePackage;
        name = cfg.themeName;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
