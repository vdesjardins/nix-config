{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  terminal = "${config.programs.wezterm.package}/bin/wezterm";
  cfg = config.programs.rofi;
in {
  config = mkIf cfg.enable {
    programs.rofi = {
      inherit terminal;

      theme = import ./theme.nix {
        inherit (config.lib.formats.rasi) mkLiteral;
      };

      plugins = with pkgs; [
        rofi-calc
        rofi-menugen
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
        modi = "drun,ssh,run,window,combi,calc,emoji,keys,filebrowser,file-browser-extended";
        no-lazy-grab = true;
        only-match = true;
        padding = "8";
        parse-hosts = true;
        parse-known-hosts = true;
        scroll-method = 1;
        show-icons = true;
        sort = true;
        terminal = "${terminal}";
        tokenize = true;
        window-format = "'  {c}    {t}'";
      };
    };

    home.packages = with pkgs; [
      rofi-systemd
      rofimoji
      (makeDesktopItem {
        name = "Rofi-calc";
        desktopName = "Rofi: Calculator";
        icon = "calc";
        exec = "rofi -show calc";
        categories = ["Development"];
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
        exec = "rofimoji";
      })
      (makeDesktopItem {
        name = "Rofi-systemd";
        desktopName = "Rofi: systemd";
        icon = "service";
        exec = "rofi-systemd";
      })
    ];
  };
}
