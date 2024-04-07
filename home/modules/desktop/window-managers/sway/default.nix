{
  config,
  options,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;
  inherit (pkgs) writeShellScriptBin;

  color-picker = writeShellScriptBin "color-picker" ''
    ${pkgs.grim}/bin/grim -g "''$(${pkgs.slurp}/bin/slurp -p)" -t ppm - | \
      ${pkgs.imagemagick_light}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | \
      ${pkgs.coreutils}/bin/tail -n 1 | \
      ${pkgs.coreutils}/bin/cut -d ' ' -f 4 | \
      ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  cfg = config.modules.desktop.window-managers.sway;
in {
  options.modules.desktop.window-managers.sway = {
    enable = mkEnableOption "sway";
    font = mkOption {
      type = str;
      default = "";
    };
    wallpapersPath = mkOption {
      type = str;
    };
  };

  imports = [
    ./sway
    ./swaynag
  ];

  config = mkIf cfg.enable {
    programs.zsh.shellGlobalAliases = {
      CL = "|& wl-copy";
    };

    home.packages = with pkgs; [
      alsa-utils
      arandr
      grim
      kanshi # dynamic display configuration
      papirus-icon-theme
      playerctl
      pulseaudio
      slurp
      udiskie
      wdisplays
      wev # event viewer
      wl-clipboard
      wlr-randr
      wshowkeys
      wtype
      xdg-utils
      xwayland
      ydotool
      color-picker

      (makeDesktopItem {
        name = "reboot";
        desktopName = "System: Reboot";
        icon = "system-reboot";
        exec = "systemctl reboot";
      })
      (makeDesktopItem {
        name = "shutdown";
        desktopName = "System: Shut Down";
        icon = "system-shutdown";
        exec = "systemctl shutdown";
      })
      (makeDesktopItem {
        name = "Color Picker";
        desktopName = "Color Picker";
        icon = "";
        exec = "${color-picker}/bin/color-picker";
      })
    ];
  };
}
