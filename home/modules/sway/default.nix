{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.window-manager.sway;
in {
  options.services.window-manager.sway = {
    enable = mkEnableOption "sway";
    font = mkOption {
      type = types.str;
      default = "";
    };
  };

  imports = [
    ./sway
    ./swaynag
    # ./swayidle
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      inherit (cfg) font;
    };

    wayland.windowManager.sway.swaynag = {
      enable = true;
      settings.custom.font = "${cfg.font} 10";
    };

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
