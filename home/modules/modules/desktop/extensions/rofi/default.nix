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
      default = "${config.modules.desktop.terminal.ghostty.package}/bin/ghostty";
    };

    package = mkOption {
      type = package;
      default = pkgs.rofi;
    };

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable (let
    # TODO: workaround for https://github.com/NixOS/nixpkgs/issues/298539
    plugins = [
      # pkgs.rofi-file-browser
      pkgs.rofi-menugen
      pkgs.rofi-power-menu
      pkgs.rofimoji
      (pkgs.rofi-calc.override {
        inherit (pkgs) rofi-unwrapped;
      })
    ];
  in {
    programs.rofi = {
      inherit (cfg) enable font package terminal;
      inherit plugins;

      theme = import ./theme.nix {
        inherit (config.lib.formats.rasi) mkLiteral;
      };

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
          "drun"
          "combi"
          "calc"
          "emoji:${pkgs.rofimoji}/bin/rofimoji"
          "filebrowser"
          "recursivebrowser"
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
        exec = "rofi -show filebrowser";
      })
      (makeDesktopItem {
        name = "Rofi-recursive-files";
        desktopName = "Rofi: Recursive Filebrowser";
        icon = "system-file-manager";
        exec = "rofi -show recursivebrowser";
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

    wayland.windowManager.hyprland = let
      rofi = config.programs.rofi.finalPackage;
    in {
      settings.bind = [
        "$mod, SPACE, exec, ${rofi}/bin/rofi -show drun -matching fuzzy"
        "$mod, X, exec, ${rofi}/bin/rofi -show run -matching fuzzy"
        "$mod, W, exec, ${rofi}/bin/rofi -show window -matching fuzzy"
        "$mod, C, exec, ${rofi}/bin/rofi -show ssh -matching fuzzy"
        "$mod, M, exec, ${rofi}/bin/rofi -show window -matching fuzzy"
        "$mod SHIFT, O, exec, ${rofi}/bin/rofi -show combi"
      ];
    };

    wayland.windowManager.sway = {
      config = let
        swayCfg = config.wayland.windowManager.sway.config;
        rofi = config.programs.rofi.finalPackage;
      in {
        menu = "${rofi}/bin/rofi -show drun -matching fuzzy";

        keybindings = lib.mkOptionDefault {
          "${swayCfg.modifier}+x" = "exec ${rofi}/bin/rofi -show run -matching fuzzy";
          "${swayCfg.modifier}+w" = "exec ${rofi}/bin/rofi -show window -matching fuzzy";
          "${swayCfg.modifier}+c" = "exec ${rofi}/bin/rofi -show ssh -matching fuzzy";
          "${swayCfg.modifier}+m" = "exec ${rofi}/bin/rofi -show window -matching fuzzy";
          "${swayCfg.modifier}+Shift+o" = "exec ${rofi}/bin/rofi -show combi";

          "${swayCfg.modifier}+comma" = "exec echo \"\" | ${rofi}/bin/rofi -dmenu -p 'New workspace name' | xargs -r swaymsg rename workspace to";
          "${swayCfg.modifier}+period" = "exec echo \"\" | ${rofi}/bin/rofi -dmenu -p 'New window name' | xargs -r swaymsg rename window to";
        };
      };
    };
  });
}
