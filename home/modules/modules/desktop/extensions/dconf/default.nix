{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.extensions.dconf;
in {
  options.modules.desktop.extensions.dconf = {
    enable = mkEnableOption "dconf";

    font = mkOption {
      type = str;
    };

    gtk-theme = mkOption {
      type = str;
      default = "Adwaita-dark";
    };

    color-scheme = mkOption {
      type = str;
      default = "prefer-dark";
    };

    icon-theme = mkOption {
      type = str;
      default = "Papirus-Dark";
    };
  };

  config = mkIf cfg.enable {
    dconf = {
      inherit (cfg) enable;

      settings = {
        "org/gnome/desktop/interface" = {
          inherit (cfg) gtk-theme;
          inherit (cfg) color-scheme;
          inherit (cfg) icon-theme;
        };
      };
    };
  };
}
