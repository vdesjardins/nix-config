{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.extensions.rofi-buku;
in {
  options.modules.desktop.extensions.rofi-buku = {
    enable = mkEnableOption "rofi-buku";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [rofi-buku];

    xdg.configFile."rofi-buku/config".text =
      /*
      bash
      */
      ''
        max_str_width=50
        display_type=3
        help_color="#2d7ed8";
      '';

    wayland.windowManager.sway = {
      config = let
        swayCfg = config.wayland.windowManager.sway.config;
      in {
        keybindings = lib.mkOptionDefault {
          "${swayCfg.modifier}+Shift+b" = "exec ${pkgs.rofi-buku}/bin/rofi-buku";
        };
      };
    };
  };
}
