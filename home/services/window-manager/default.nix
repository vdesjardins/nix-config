{ config, pkgs, ... }: {
  imports = [
    ./i3
    ./rofi
    ./i3status-rust
  ];


  home.packages = with pkgs; [
    wmctrl
    arandr
    maim
    scrot
    slock
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

  programs.chromium = {
    enable = true;
  };

  programs.feh = {
    enable = true;
  };

  # https://github.com/unix121/i3wm-themer/blob/master/themes/006.json
  xresources.properties = {
    "*background" = "#1c1c22";
    "*foreground" = "#d9d6ca";
    "*cursorcolor" = "#d9d6ca";
    "*color0" = "#1c1c22";
    "*color1" = "#7e6565";
    "*color2" = "#85aab6";
    "*color3" = "#90a996";
    "*color4" = "#3e646f";
    "*color5" = "#817f98";
    "*color6" = "#9aa7c0";
    "*color7" = "#d9d6ca";
    "*color8" = "#59596c";
    "*color9" = "#807171";
    "*color10" = "#3e646f";
    "*color11" = "#badbc2";
    "*color12" = "#5c828d";
    "*color13" = "#9b98b7";
    "*color14" = "#b2b7c0";
    "*color15" = "#d9d6ca";
  };

  services.picom = {
    enable = true;
    blur = true;
    shadow = true;
    activeOpacity = "0.8";
    inactiveDim = "0.2";
    inactiveOpacity = "0.8";
    menuOpacity = "0.8";
  };

}
