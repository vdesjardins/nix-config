{
  config,
  pkgs,
  options,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.window-managers.i3;
in {
  options.modules.desktop.window-managers.i3 = {
    enable = mkEnableOption "i3";
    font = mkOption {
      type = str;
    };
  };

  imports = [
    ./i3
  ];

  config = lib.mkIf cfg.enable {
    programs.zsh.shellGlobalAliases = {
      CL = "|& xclip -r -selection c";
    };

    home.packages = with pkgs; [
      libinput-gestures
      alsa-utils
      wmctrl
      arandr
      maim
      pulseaudio
      playerctl
      scrot
      slock
      xdotool
      xsel
      xclip
      xorg.xmodmap
      xorg.xev
      glxinfo
      # TODO: should move those elsewhere maybe
      flameshot

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

    # [theme]
    # https://github.com/folke/tokyonight.nvim/blob/main/extras/xresources/tokyonight_storm.Xresources
    # ! TokyoNight colors for Xresources
    xresources.properties = {
      "*background" = "#24283b";
      "*foreground" = "#c0caf5";
      "*color0" = "#1d202f";
      "*color1" = "#f7768e";
      "*color2" = "#9ece6a";
      "*color3" = "#e0af68";
      "*color4" = "#7aa2f7";
      "*color5" = "#bb9af7";
      "*color6" = "#7dcfff";
      "*color7" = "#a9b1d6";
      "*color8" = "#414868";
      "*color9" = "#f7768e";
      "*color10" = "#9ece6a";
      "*color11" = "#e0af68";
      "*color12" = "#7aa2f7";
      "*color13" = "#bb9af7";
      "*color14" = "#7dcfff";
      "*color15" = "#c0caf5";

      "xterm.termName" = "xterm-256color";
      "xterm*faceName" = "Monaspace Radon";
      "xterm*faceSize" = "12";
      "xterm*loginshell" = true;
      "xterm*metaSendsEscape" = true;
      "xterm*scrollBar" = false;
      "xterm*rightScrollBar" = false;
      "xterm*scrollTtyOutput" = false;
      #"xterm*background" = "black";
      #"xterm*foreground" = "white";
    };

    services.picom = {
      enable = true;
      #blur = true;
      shadow = true;
      activeOpacity = 1.0;
      #inactiveDim = 0.2;
      inactiveOpacity = 1.0;
      menuOpacity = 1.0;
    };
  };
}
