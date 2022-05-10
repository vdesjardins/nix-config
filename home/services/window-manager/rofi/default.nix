{ config, lib, pkgs, ... }:
let
  terminal = "${pkgs.unstable.wezterm}/bin/wezterm";
in
{
  programs.rofi = {
    enable = true;
    font = "pango:JetBrainsMono Nerd Font Mono 10";
    inherit terminal;
    theme = "Arc-Dark";
    pass.enable = true;
    plugins = with pkgs; [
      rofi-calc
      rofi-menugen
      rofi-pass
      rofi-systemd
      rofi-emoji
      rofi-file-browser
    ];

    extraConfig = {
      async-pre-read = "50";
      click-to-exit = true;
      combi-modi = "drun,ssh,run,window";
      display-combi = "ALL";
      display-drun = "APP";
      display-run = "EXEC";
      display-ssh = "SSH";
      display-window = "WIN";
      drun-display-format = "'  <b>{name}</b>  <small>{comment}</small>'";
      drun-match-fields = "name,exec,comment,categories,generic";
      drun-show-actions = true;
      markup-rows = true;
      matching = "fuzzy";
      modi = "drun,ssh,run,window,combi";
      no-lazy-grab = true;
      only-match = true;
      padding = "8";
      parse-hosts = true;
      parse-known-hosts = true;
      scroll-method = "1";
      show-icons = true;
      sort = true;
      terminal = "${terminal}";
      tokenize = true;
      window-format = "'  {c}    {t}'";
    };
  };

  home.packages = with pkgs; [
    (makeDesktopItem {
      name = "Rofi-calc";
      desktopName = "Rofi: Calculator";
      icon = "calc";
      exec = "rofi -show calc";
      categories = "Development";
    })
    (makeDesktopItem {
      name = "Rofi-files";
      desktopName = "Rofi: Filebrowser";
      icon = "system-file-manager";
      exec = "rofi -show file-browser-extended";
    })
    (makeDesktopItem {
      name = "Rofi-emojis";
      desktopName = "Rofi: emoji";
      icon = "face-smile";
      exec = "rofi -show emoji";
    })
  ];
}
