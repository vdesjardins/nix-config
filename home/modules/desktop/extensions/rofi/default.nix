{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package str;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.meta) getExe;

  cfg = config.modules.desktop.extensions.rofi;
in {
  options.modules.desktop.extensions.rofi = {
    enable = mkEnableOption "rofi";

    terminal = mkOption {
      type = str;
      default = "${config.modules.desktop.terminal.wezterm.package}/bin/wezterm";
    };

    package = mkOption {
      type = package;
      default = pkgs.unstable.wezterm;
    };

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      inherit (cfg) enable font package terminal;

      theme = import ./theme.nix {
        inherit (config.lib.formats.rasi) mkLiteral;
      };

      plugins = with pkgs; [
        rofi-calc
        rofi-menugen
        rofi-emoji
        rofi-file-browser
        rofi-power-menu
      ];

      extraConfig = {
        async-pre-read = "50";
        click-to-exit = true;
        combi-modi = "drun,ssh,run,window";

        display-combi = "⭐ All";
        display-ssh = "🐡 SSH";

        display-run = "   Exec ";
        display-drun = "   Run ";
        display-emoji = "   Emoji ";
        display-window = " 﩯 Window ";
        display-power-menu = "  Power Menu ";

        drun-display-format = " <b>{name}</b>  <small>{comment}</small>";

        drun-match-fields = "name,exec,comment,categories,generic";

        drun-show-actions = true;
        markup-rows = true;
        matching = "fuzzy";

        modi = concatStringsSep "," [
          "calc"
          "combi"
          "drun"
          "emoji"
          "file-browser-extended"
          "filebrowser"
          "keys"
          "run"
          "ssh"
          "window"
          "powermenu:${getExe pkgs.rofi-power-menu}"
          "systemd:${getExe pkgs.rofi-systemd}"
        ];

        no-lazy-grab = true;
        only-match = true;
        padding = "8";
        parse-hosts = true;
        parse-known-hosts = true;
        scroll-method = 1;
        show-icons = true;
        sort = true;
        terminal = "${cfg.terminal}";
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
