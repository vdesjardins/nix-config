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
    # ./swayidle
  ];

  config = mkIf cfg.enable {
    programs.zsh.shellGlobalAliases = {
      CL = "|& wl-copy";
    };

    home.packages = with pkgs; [
      alsa-utils
      arandr
      grim
      papirus-icon-theme
      pulseaudio
      playerctl
      slurp
      swayidle
      shotman
      udiskie
      wev # event viewer
      wl-clipboard
      wlr-randr
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
