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

  cfg = config.modules.desktop.window-managers.sway;
in {
  options.modules.desktop.window-managers.sway = {
    enable = mkEnableOption "sway";
    font = mkOption {
      type = str;
      default = "";
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
      shotman
      slurp
      swayidle
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
    ];
  };
}
