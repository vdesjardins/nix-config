{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.handy;

  # Helper script for push-to-talk on Wayland
  handy-push-to-talk = pkgs.writeShellScriptBin "handy-push-to-talk" ''
    case "$1" in
      --start)
        # Check if handy process is running
        if ! ${pkgs.procps}/bin/pkill -0 -n -x handy 2>/dev/null; then
          ${pkgs.libnotify}/bin/notify-send -u critical "Handy" "Handy process not running"
          exit 1
        fi
        # Send USR2 signal to toggle recording ON
        ${pkgs.procps}/bin/pkill -USR2 -n -x handy
        ;;
      --stop)
        # Check if handy process is running
        if ! ${pkgs.procps}/bin/pkill -0 -n -x handy 2>/dev/null; then
          ${pkgs.libnotify}/bin/notify-send -u critical "Handy" "Handy process not running"
          exit 1
        fi
        # Send USR2 signal to toggle recording OFF and transcribe
        ${pkgs.procps}/bin/pkill -USR2 -n -x handy
        ;;
      *)
        echo "Usage: $0 [--start|--stop]"
        exit 1
        ;;
    esac
  '';
in {
  options.modules.shell.tools.handy = {
    enable = mkEnableOption "handy - offline speech-to-text application";

    keyboard-shortcut = mkOption {
      type = types.str;
      default = "Alt+Shift+H";
      description = "Default keyboard shortcut to trigger transcription";
    };

    wayland = {
      enable = mkEnableOption "Wayland push-to-talk support (requires Hyprland)";

      key-binding = mkOption {
        type = types.str;
        default = "SUPER ALT CTRL, T";
        description = "Hyprland keybinding for push-to-talk (format: MOD1 MOD2 MOD3, key)";
      };

      auto-start =
        mkEnableOption "Auto-start handy via Hyprland on startup"
        // {
          default = true;
        };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.handy
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
        # Text input tools for Linux - required for pasting transcribed text
        # wtype is preferred for Wayland, xdotool for X11, dotool for both
        pkgs.wtype
        pkgs.dotool
      ])
      ++ (lib.optionals cfg.wayland.enable [
        # Push-to-talk helper script and notification support
        handy-push-to-talk
        pkgs.libnotify
      ]);

    # Hyprland integration for Wayland push-to-talk
    wayland.windowManager.hyprland.settings = mkIf (cfg.wayland.enable && pkgs.stdenv.isLinux) {
      # Auto-start handy daemon on Hyprland startup
      exec-once = lib.optionals cfg.wayland.auto-start ["handy"];

      # Keybinding for push-to-talk: SUPER+ALT+CTRL+T (keypress)
      bind = [
        "${cfg.wayland.key-binding}, exec, ${handy-push-to-talk}/bin/handy-push-to-talk --start"
      ];

      # Keybinding for push-to-talk release: SUPER+ALT+CTRL+T (keyrelease)
      bindr = [
        "${cfg.wayland.key-binding}, exec, ${handy-push-to-talk}/bin/handy-push-to-talk --stop"
      ];
    };
  };
}
