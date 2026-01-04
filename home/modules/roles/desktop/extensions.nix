{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) str package;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.extensions;
in {
  options.roles.desktop.extensions = {
    enable = mkEnableOption "desktop.extensions";

    # GTK configuration options (merged from gtk.nix)
    gtk = {
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
  };

  config = mkIf cfg.enable {
    # GTK configuration (from gtk.nix)
    gtk = {
      enable = true;

      inherit (cfg.gtk) colorScheme;

      iconTheme = {
        package = cfg.gtk.iconPackage;
        name = cfg.gtk.iconName;
      };

      theme = {
        package = cfg.gtk.themePackage;
        name = cfg.gtk.themeName;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    # QT configuration (from qt.nix)
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    # Extension modules
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
