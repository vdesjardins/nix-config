{
  config,
  pkgs,
  lib,
  naturalMouseScrolling,
  ...
}: {
  services = {
    picom = {
      enable = true;
    };

    greenclip = {
      enable = true;
    };

    xserver = {
      enable = true;
      layout = "us,ca";
      xkbVariant = ",fr";

      dpi = 220;

      autoRepeatDelay = 150;
      autoRepeatInterval = 25;

      exportConfiguration = true;

      xkbOptions = lib.concatStringsSep "," [
        "grp:alt_space_toggle,caps:ctrl_modifier"
      ];

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "scale";
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;

        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
          xrandr-mbp
        '';
      };

      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };

      libinput = {
        enable = true;
        mouse = {
          naturalScrolling = naturalMouseScrolling;
        };
        touchpad = {
          naturalScrolling = naturalMouseScrolling;
        };
      };
    };
  };
}
