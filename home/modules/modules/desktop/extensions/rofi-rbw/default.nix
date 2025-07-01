{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.extensions.rofi-rbw;
in {
  options.modules.desktop.extensions.rofi-rbw = {
    enable = mkEnableOption "rofi-rbw";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-rbw
    ];

    wayland.windowManager.sway = {
      config = let
        swayCfg = config.wayland.windowManager.sway.config;
      in {
        keybindings = lib.mkOptionDefault {
          "${swayCfg.modifier}+p" = "exec ${pkgs.rofi-rbw}/bin/rofi-rbw";
        };
      };
    };
  };
}
