{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe getExe' mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.window-managers.niri;

  terminal = "ghostty";
  fileManager = "ghostty --class=org.my.yazi -e yazi";
  browser = "firefox";
  passwordManager = "bitwarden-desktop";
in {
  options.modules.desktop.window-managers.niri = {
    enable = mkEnableOption "niri wm";

    wallpapersPath = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.shellGlobalAliases.CL = "wl-copy";

    home.packages = with pkgs; [
      alsa-utils
      arandr
      brightnessctl
      clipse
      grim
      jq
      papirus-icon-theme
      playerctl
      pulseaudio
      slurp
      swaybg
      wev
      wl-clipboard
      wlr-randr
      wshowkeys
      wtype
      xdg-utils
      ydotool
    ];

    services = {
      awww.enable = true;
      polkit-gnome.enable = true;
    };

    systemd.user.services = {
      polkit-gnome.Unit.ConditionEnvironment = lib.mkForce [
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP=niri"
      ];
    };

    wayland.windowManager.niri = {
      enable = true;

      settings = {
        prefer-no-csd = {};
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              variant = "altgr-intl";
              options = "grp:alt_space_toggle,caps:ctrl_modifier";
              model = "pc104";
            };
            repeat-delay = 200;
            repeat-rate = 35;
          };

          mouse = {
            accel-profile = "adaptive";
            natural-scroll = {};
          };

          touchpad = {
            tap = {};
            accel-profile = "adaptive";
            middle-emulation = {};
            natural-scroll = {};
            scroll-factor = 2.0;
          };

          focus-follows-mouse._props.max-scroll-amount = "0%";
        };

        layout = {
          gaps = 10;
          center-focused-column = "never";
          always-center-single-column = {};

          preset-column-widths._children = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
            {proportion = 0.95;}
          ];

          default-column-width.proportion = 0.95;

          focus-ring = {
            width = 4;
            active-color = "#7aa2f7";
            inactive-color = "#24283b";
          };

          border.off = {};
        };

        hotkey-overlay.skip-at-startup = {};

        binds = {
          "Mod+H".focus-column-or-monitor-left = {};
          "Mod+J".focus-window-or-monitor-down = {};
          "Mod+K".focus-window-or-monitor-up = {};
          "Mod+L".focus-column-or-monitor-right = {};

          "Mod+Shift+H".move-column-left-or-to-monitor-left = {};
          "Mod+Shift+J".move-window-down = {};
          "Mod+Shift+K".move-window-up = {};
          "Mod+Shift+L".move-column-right-or-to-monitor-right = {};

          "Mod+BracketLeft" = {
            _props.hotkey-overlay-title = "Consume or Expel Window Left";
            consume-or-expel-window-left = {};
          };
          "Mod+BracketRight" = {
            _props.hotkey-overlay-title = "Consume or Expel Window Right";
            consume-or-expel-window-right = {};
          };
          "Mod+Comma" = {
            _props.hotkey-overlay-title = "Stack Right Window in Column";
            consume-window-into-column = {};
          };
          "Mod+Period" = {
            _props.hotkey-overlay-title = "Expel Bottom Window from Column";
            expel-window-from-column = {};
          };

          "Mod+1".focus-workspace = "1";
          "Mod+2".focus-workspace = "2";
          "Mod+3".focus-workspace = "3";
          "Mod+4".focus-workspace = "4";
          "Mod+5".focus-workspace = "5";
          "Mod+6".focus-workspace = "6";
          "Mod+7".focus-workspace = "7";
          "Mod+8".focus-workspace = "8";
          "Mod+9".focus-workspace = "9";
          "Mod+0".focus-workspace = "10";

          "Mod+Shift+1".move-column-to-workspace = "1";
          "Mod+Shift+2".move-column-to-workspace = "2";
          "Mod+Shift+3".move-column-to-workspace = "3";
          "Mod+Shift+4".move-column-to-workspace = "4";
          "Mod+Shift+5".move-column-to-workspace = "5";
          "Mod+Shift+6".move-column-to-workspace = "6";
          "Mod+Shift+7".move-column-to-workspace = "7";
          "Mod+Shift+8".move-column-to-workspace = "8";
          "Mod+Shift+9".move-column-to-workspace = "9";
          "Mod+Shift+0".move-column-to-workspace = "10";

          "Mod+Return" = {
            _props.hotkey-overlay-title = "Open Terminal";
            spawn = [terminal];
          };
          "Mod+Shift+F" = {
            _props.hotkey-overlay-title = "Open File Manager";
            spawn-sh = fileManager;
          };
          "Mod+B" = {
            _props.hotkey-overlay-title = "Open Browser";
            spawn = [browser];
          };
          "Mod+M" = {
            _props.hotkey-overlay-title = "Open Gmail";
            spawn = [browser "--new-window" "gmail.com"];
          };
          "Mod+N" = {
            _props.hotkey-overlay-title = "Open Neovim";
            spawn = [terminal "-e" "nvim"];
          };
          "Mod+T" = {
            _props.hotkey-overlay-title = "Open System Monitor";
            spawn = [terminal "-e" "btop"];
          };
          "Mod+Shift+D" = {
            _props.hotkey-overlay-title = "Open Lazydocker";
            spawn = [terminal "-e" "lazydocker"];
          };
          "Mod+G" = {
            _props.hotkey-overlay-title = "Open Signal";
            spawn = ["signal-desktop"];
          };
          "Mod+O" = {
            _props.hotkey-overlay-title = "Open Logseq";
            spawn = ["logseq"];
          };
          "Mod+Shift+V" = {
            _props.hotkey-overlay-title = "Open Password Manager";
            spawn = [passwordManager];
          };
          "Mod+E" = {
            _props.hotkey-overlay-title = "Open Calendar";
            spawn = [browser "--new-window" "calendar.google.com"];
          };

          "Mod+V".toggle-window-floating = {};
          "Mod+F".fullscreen-window = {};
          "Mod+Z" = {
            _props.hotkey-overlay-title = "Zoom or Restore Column Stack";
            toggle-column-tabbed-display = {};
          };
          "Mod+Shift+Q".close-window = {};
          "Mod+R".switch-preset-column-width = {};
          "Mod+Alt+H".set-column-width = "-50";
          "Mod+Alt+L".set-column-width = "+50";
          "Mod+Alt+J".set-window-height = "+50";
          "Mod+Alt+K".set-window-height = "-50";

          "Mod+Shift+X" = {
            _props.hotkey-overlay-title = "Lock Screen";
            spawn = [(getExe pkgs.hyprlock)];
          };
          "Mod+Shift+Slash" = {
            _props.hotkey-overlay-title = "Show Shortcuts";
            show-hotkey-overlay = {};
          };
          "Mod+Shift+Space" = {
            _props.hotkey-overlay-title = "Show Overview";
            toggle-overview = {};
          };

          "Print".screenshot = {};
          "Shift+Print".screenshot-window = {};
          "Ctrl+Print".screenshot-screen = {};

          "Mod+Shift+C" = {
            _props.hotkey-overlay-title = "Clipboard History";
            spawn-sh = "${pkgs.cliphist}/bin/cliphist list | ${config.programs.rofi.finalPackage}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          };

          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = [(getExe' pkgs.wireplumber "wpctl") "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"];
          };
          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = [(getExe' pkgs.wireplumber "wpctl") "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
          };
          "XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn = [(getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          };
          "XF86AudioMicMute" = {
            _props.allow-when-locked = true;
            spawn = [(getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          };
          "XF86MonBrightnessUp" = {
            _props.allow-when-locked = true;
            spawn = [(getExe pkgs.brightnessctl) "-e4" "-n2" "set" "5%+"];
          };
          "XF86MonBrightnessDown" = {
            _props.allow-when-locked = true;
            spawn = [(getExe pkgs.brightnessctl) "-e4" "-n2" "set" "5%-"];
          };
        };
      };

      extraConfig = ''
        output "DP-2" {
            mode "3840x2160"
            position x=0 y=0
            scale 1
            transform "90"
        }

        output "DP-3" {
            mode "3840x2160"
            position x=2160 y=529
            scale 1
        }

        workspace "1" { open-on-output "DP-3"; }
        workspace "2" { open-on-output "DP-3"; }
        workspace "3" { open-on-output "DP-3"; }
        workspace "4" { open-on-output "DP-3"; }
        workspace "5" { open-on-output "DP-3"; }
        workspace "6" { open-on-output "DP-3"; }
        workspace "7" { open-on-output "DP-2"; }
        workspace "8" { open-on-output "DP-2"; }
        workspace "9" { open-on-output "DP-2"; }
        workspace "10" { open-on-output "DP-2"; }

        spawn-at-startup "${getExe pkgs.wl-clip-persist}" "--clipboard" "regular"
        spawn-at-startup "${getExe pkgs.clipse}" "-listen"
        spawn-sh-at-startup "${getExe pkgs.awww} img $(${pkgs.findutils}/bin/find -L ${cfg.wallpapersPath} -maxdepth 1 -type f | ${pkgs.coreutils}/bin/shuf -n 1)"

        window-rule {
            match app-id="^org\\.my\\.yazi$"
            open-floating true
            default-column-width { proportion 0.7; }
            default-window-height { proportion 0.7; }
        }
      '';
    };
  };
}
