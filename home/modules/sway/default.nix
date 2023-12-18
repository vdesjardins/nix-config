{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.window-manager.mySway;
in {
  options.services.window-manager.mySway = {
    enable = mkEnableOption "mySway";
    font = mkOption {
      type = types.str;
    };
  };

  imports = [
    ./sway
    ./mako
    ./swaynag
    # ./swayidle
  ];

  config = {
    wayland.windowManager.mySway.font = cfg.font;
    services.mako.font = "${cfg.font} 10";
    wayland.windowManager.sway.swaynag.settings.custom.font = "${cfg.font} 10";

    home.packages = with pkgs; [
      alsa-utils
      wl-clipboard
      wtype
      arandr
      grim
      pulseaudio
      playerctl
      slurp
      swayidle
      shotman
      udiskie

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
