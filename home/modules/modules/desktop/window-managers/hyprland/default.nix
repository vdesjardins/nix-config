{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf getExe;
  inherit (lib.types) str;

  cfg = config.modules.desktop.window-managers.hyprland;
in {
  options.modules.desktop.window-managers.hyprland = {
    enable = mkEnableOption "hyprland wm";

    wallpapersPath = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    services.hyprpolkitagent.enable = true;
    services.hyprpaper.enable = true;
    services.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = cfg.wallpapersPath;
          sorting = "random";
          duration = "10m";
          mode = "center";
        };
      };
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof ${getExe pkgs.hyprlock} || ${getExe pkgs.hyprlock}"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on && ${getExe pkgs.brightnessctl} -r"; # screen on when activity is detected
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          no_fade_in = false;
        };

        background = {
          monitor = "";
          color = "rgba(26,27,38,1.0)"; # #1a1b26 solid color
        };

        animations = {
          enabled = false;
        };

        input-field = {
          monitor = "";
          size = "600, 100";
          position = "0, 0";
          halign = "center";
          valign = "center";

          inner_color = "rgba(26,27,38,0.8)"; # #1a1b26 with opacity
          outer_color = "rgba(205,214,244,1.0)"; # #cdd6f4
          outline_thickness = 4;

          font_family = "CaskaydiaMono Nerd Font";
          font_size = 32;
          font_color = "rgba(205,214,244,1.0)";

          placeholder_color = "rgba(205,214,244,0.6)";
          placeholder_text = "Enter Password 󰈷 ";
          check_color = "rgba(68, 157, 171, 1.0)";
          fail_text = "Wrong";

          rounding = 0;
          shadow_passes = 0;
          fade_on_empty = false;
        };

        auth = {
          "fingerprint:enabled" = true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$terminal" = "ghostty";
        "$fileManager" = "nautilus --new-window";
        "$browser" = "firefox";
        "$music" = "spotify";
        "$messenger" = "signal-desktop";
        "$webapp" = "$browser --new-window";
        "$passwordManager" = "bitwarden-desktop";

        "$mod" = "SUPER";

        monitor = [
          "DP-2, 3840x2160, 0x0, 1, transform, 1"
          "DP-3, 3840x2160, 2160x529, 1"
          ", preferred, auto, 1"
        ];

        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "grp:alt_space_toggle,caps:ctrl_modifier";
          kb_model = "pc104";
          repeat_delay = "200";
          repeat_rate = "35";
          follow_mouse = 1;

          natural_scroll = true;

          accel_profile = "adaptive";

          touchpad = {
            middle_button_emulation = true;
            scroll_factor = "2.0";
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = false;
        };

        bind = [
          # Focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          # Move
          "$mod SHIFT, h, swapwindow, l"
          "$mod SHIFT, j, swapwindow, d"
          "$mod SHIFT, k, swapwindow, u"
          "$mod SHIFT, l, swapwindow, r"

          # Swtich to workspace
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move container to workspace
          "$mod SHIFT, 1, movetoworkspacesilent, 1"
          "$mod SHIFT, 2, movetoworkspacesilent, 2"
          "$mod SHIFT, 3, movetoworkspacesilent, 3"
          "$mod SHIFT, 4, movetoworkspacesilent, 4"
          "$mod SHIFT, 5, movetoworkspacesilent, 5"
          "$mod SHIFT, 6, movetoworkspacesilent, 6"
          "$mod SHIFT, 7, movetoworkspacesilent, 7"
          "$mod SHIFT, 8, movetoworkspacesilent, 8"
          "$mod SHIFT, 9, movetoworkspacesilent, 9"
          "$mod SHIFT, 0, movetoworkspacesilent, 10"

          # Control tiling
          "$mod, J, togglesplit, # dwindle"
          "$mod, P, pseudo, # dwindle"
          "$mod, V, togglefloating,"

          # Screenshots
          ", PRINT, exec, ${getExe pkgs.hyprshot} -m region"
          "SHIFT, PRINT, exec, ${getExe pkgs.hyprshot} -m window"
          "CTRL, PRINT, exec, ${getExe pkgs.hyprshot} -m output"

          # Color picker
          "SUPER, PRINT, exec, ${getExe pkgs.hyprpicker} -a"

          # clipboard
          "$mod Shift, C, exec, ${pkgs.cliphist}/bin/cliphist list | ${config.programs.rofi.finalPackage}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | wl-copy"

          # Start default apps
          "$mod, return, exec, $terminal"
          "$mod SHIFT, F, exec, $fileManager"
          "$mod, B, exec, $browser"
          "$mod, M, exec, $music"
          "$mod, N, exec, $terminal -e nvim"
          "$mod, T, exec, $terminal -e btop"
          "$mod SHIFT, D, exec, $terminal -e lazydocker"
          "$mod, G, exec, $messenger"
          "$mod, O, exec, logseq"
          "$mod, slash, exec, $passwordManager"

          # fullscreen
          "$mod, F, fullscreen"

          # kill app
          "$mod SHIFT, q, killactive"

          # lock screen
          "$mod SHIFT, X, exec, ${getExe pkgs.hyprlock}"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%+"
          ",XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%-"
        ];

        exec-once = [
          "${getExe pkgs.hypridle} & ${getExe pkgs.mako} & ${getExe pkgs.waybar} & ${getExe pkgs.fcitx5}"
          "${getExe pkgs.wl-clip-persist} --clipboard regular & ${getExe pkgs.clipse} -listen"
        ];

        workspace = [
          "1, monitor:DP-3, default:true, persistent:true"
          "2, monitor:DP-3"
          "3, monitor:DP-3"
          "4, monitor:DP-3"
          "5, monitor:DP-3"
          "6, monitor:DP-3"
          "7, monitor:DP-2"
          "8, monitor:DP-2"
          "9, monitor:DP-2"
          "10, monitor:DP-2, default:true, persistent:true"
        ];

        windowrule = [
          "float, class:(clipse)"
          "size 622 652, class:(clipse)"
          "stayfocused, class:(clipse)"
        ];

        # Workaround for wrong wpaperd texture on vertical screen
        # https://github.com/hyprwm/Hyprland/issues/9408#issuecomment-2661608482
        render = {
          expand_undersized_textures = false;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 0;

          shadow = {
            enabled = true;
            range = 2;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = "yes";

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 0, 0, ease"
          ];
        };

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
          force_split = 2; # Always split on the right
        };

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master = {
          new_status = "master";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
    };
  };
}
