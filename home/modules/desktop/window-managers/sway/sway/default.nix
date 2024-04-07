{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  mod = "Mod4";

  inherit (config.modules.desktop.window-managers.sway) wallpapersPath;

  random-wallpaper = pkgs.writeShellScript "random-wallpaper" ''
    ${pkgs.findutils}/bin/find -L ${wallpapersPath} -type f | ${pkgs.coreutils}/bin/shuf -n 1
  '';

  locker = "${config.programs.swaylock.package}/bin/swaylock --image `${random-wallpaper}`";

  terminal = "wezterm";

  modeGaps = "Gaps: (o) outer, (i) inner";
  modeGapInner = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  modeGapsOuter = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";

  cfg = config.modules.desktop.window-managers.sway;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      inherit (cfg) enable;

      config = {
        modifier = mod;

        input = {
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "altgr-intl";
            xkb_options = "grp:alt_space_toggle,caps:ctrl_modifier";
            xkb_model = "pc104";
            repeat_delay = "200";
            repeat_rate = "35";
          };

          "type:touchpad" = {
            accel_profile = "adaptive";
            click_method = "clickfinger";
            drag = "enabled";
            dwt = "enabled";
            middle_emulation = "enabled";
            pointer_accel = "0.5";
            scroll_method = "two_finger";
            scroll_factor = "1.1";
            tap = "enabled";
          };
        };

        output = {
          "Virtual-1" = {
            mode = "3840x2160@60Hz";
          };
          "HDMI-A-1" = {
            mode = "3840x2160@60Hz";
            transform = "270";
            position = "-2160 -529";
          };
          "DP-1" = {
            mode = "3840x2160@60Hz";
            position = "0 0";
          };
          "*" = {
            background = "`${random-wallpaper}` fill";
          };
        };

        defaultWorkspace = "workspace ${ws1}";

        workspaceAutoBackAndForth = true;

        focus = {
          followMouse = true;
          mouseWarping = "container";
        };

        fonts = {
          names = [cfg.font];
          size = 10.0;
        };

        gaps = {
          inner = 5;
          smartBorders = "on";
          outer = 5;
        };

        inherit terminal;

        window = {
          titlebar = false;
          border = 2;
        };

        keybindings = lib.mkOptionDefault {
          # Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+g" = "exec ${pkgs.wmfocus}/bin/wmfocus";

          # Move
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # Move to workspace
          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";
          "${mod}+5" = "workspace ${ws5}";
          "${mod}+6" = "workspace ${ws6}";
          "${mod}+7" = "workspace ${ws7}";
          "${mod}+8" = "workspace ${ws8}";
          "${mod}+9" = "workspace ${ws9}";
          "${mod}+0" = "workspace ${ws10}";

          # Move container to workspace
          "${mod}+Shift+1" = "move container to workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}";
          "${mod}+Shift+5" = "move container to workspace ${ws5}";
          "${mod}+Shift+6" = "move container to workspace ${ws6}";
          "${mod}+Shift+7" = "move container to workspace ${ws7}";
          "${mod}+Shift+8" = "move container to workspace ${ws8}";
          "${mod}+Shift+9" = "move container to workspace ${ws9}";
          "${mod}+Shift+0" = "move container to workspace ${ws10}";

          # Move container to workspace and focus
          "${mod}+Control+1" = "move container to workspace ${ws1}; workspace ${ws1}";
          "${mod}+Control+2" = "move container to workspace ${ws2}; workspace ${ws2}";
          "${mod}+Control+3" = "move container to workspace ${ws3}; workspace ${ws3}";
          "${mod}+Control+4" = "move container to workspace ${ws4}; workspace ${ws4}";
          "${mod}+Control+5" = "move container to workspace ${ws5}; workspace ${ws5}";
          "${mod}+Control+6" = "move container to workspace ${ws6}; workspace ${ws6}";
          "${mod}+Control+7" = "move container to workspace ${ws7}; workspace ${ws7}";
          "${mod}+Control+8" = "move container to workspace ${ws8}; workspace ${ws8}";
          "${mod}+Control+9" = "move container to workspace ${ws9}; workspace ${ws9}";
          "${mod}+Control+0" = "move container to workspace ${ws10}; workspace ${ws10}";

          # Move workspace between screens
          "${mod}+Control+j" = "move workspace to output left";
          "${mod}+Control+semicolon" = "move workspace to output right";

          # fullscreen
          "${mod}+f" = "fullscreen";

          # start a terminal
          "${mod}+Return" = "exec ${terminal}";

          # lock screen
          "${mod}+Shift+x" = "exec --no-startup-id ${locker}";

          # reload config
          "${mod}+Shift+r" = "reload";

          # toggle tiling / floating
          "${mod}+Shift+space" = "floating toggle";

          # move the currently focused window to the scratchpad
          "${mod}+Shift+minus" = "move scratchpad";

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          "${mod}+minus" = "scratchpad show";

          # Multimedia Key Controls from https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759
          # wireplumber controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 5%+"; #increase sound volume
          "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 5%-"; #decrease sound volume
          "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle"; # mute sound

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec brightnessctl set +50"; # increase screen brightness
          "XF86MonBrightnessDown" = "exec brightnessctl set 50-"; # decrease screen brightness

          # Media player controls
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          # Screenshots
          "${mod}+Print" = ''exec --no-startup-id swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${getExe pkgs.slurp} | ${getExe pkgs.grim} -g - - | ${getExe pkgs.swappy} -f -'';
          "${mod}+Shift+Print" = ''exec --no-startup-id ${getExe pkgs.slurp} | ${getExe pkgs.grim} -g - - | ${getExe pkgs.swappy} -f -'';
          "${mod}+Ctrl+Print" = ''exec --no-startup-id swaymsg -t get_tree | jq -r '.. | select(.active?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${getExe pkgs.slurp} | ${getExe pkgs.grim} -g - - | ${getExe pkgs.swappy} -f -'';

          # clipboard
          "${mod}+Shift+c" = ''exec "${pkgs.cliphist}/bin/cliphist list | ${config.programs.rofi.finalPackage}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | wl-copy"'';

          # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner Gaps.
          # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
          # If you also press Shift with these keys, the change will be global for all workspaces.
          "${mod}+Shift+g" = "mode \"${modeGaps}\"";

          # Launch Browser
          "${mod}+b" = "exec firefox";

          # kill app
          "${mod}+Shift+q" = "kill";

          # quick shortcut help
          "${mod}+Shift+slash" = "exec --no-startup-id swaycheatsheet-win";
        };

        modes = {
          "${modeGaps}" = {
            i = "mode \"${modeGapInner}\"";
            o = "mode \"${modeGapsOuter}\"";
            Return = "mode default";
            Escape = "mode default";
          };
          "${modeGapInner}" = {
            plus = "gaps inner current plus 5";
            minus = "gaps inner current minus 5";
            "0" = "gaps inner current set 0";

            "Shift+plus" = "gaps inner all plus 5";
            "Shift+minus" = "gaps inner all minus 5";
            "Shift+0" = "gaps inner all set 0";

            Return = "mode default";
            Escape = "mode default";
          };
          "${modeGapsOuter}" = {
            plus = "gaps outer current plus 5";
            minus = "gaps outer current minus 5";
            "0" = "gaps outer current set 0";

            "Shift+plus" = "gaps outer all plus 5";
            "Shift+minus" = "gaps outer all minus 5";
            "Shift+0" = "gaps outer all set 0";

            Return = "mode default";
            Escape = "mode default";
          };

          "resize" = {
            "h" = "resize shrink width 20 px or 20 ppt";
            "j" = "resize grow height 20 px or 20 ppt";
            "k" = "resize shrink height 20 px or 20 ppt";
            "l" = "resize grow width 20 px or 20 ppt";
            "Shift+h" = "resize shrink width 5 px or 5 ppt";
            "Shift+j" = "resize grow height 5 px or 5 ppt";
            "Shift+k" = "resize shrink height 5 px or 5 ppt";
            "Shift+l" = "resize grow width 5 px or 5 ppt";

            Return = "mode default";
            Escape = "mode default";
          };
        };

        startup = [
          {
            command = "udiskie";
          }
          {
            command = "autotiling";
            always = true;
          }
        ];
      };

      extraConfig = ''
        # Workspace ouput preferences
        workspace 1 output DP-1 HDMI-A-1
        workspace 2 output DP-1 HDMI-A-1
        workspace 3 output DP-1 HDMI-A-1
        workspace 4 output DP-1 HDMI-A-1
        workspace 5 output DP-1 HDMI-A-1
        workspace 6 output DP-1 HDMI-A-1
        workspace 7 output HDMI-A-1 DP-1
        workspace 8 output HDMI-A-1 DP-1
        workspace 9 output HDMI-A-1 DP-1
        workspace 10 output HDMI-A-1 DP-1

        set {
          $ii inhibit_idle focus
          $game inhibit_idle focus; floating enable; border none; fullscreen enable; shadows disable
          $popup floating enable; border pixel 1; sticky enable; shadows enable
          $float floating enable; border pixel 1; shadows enable
          $video inhibit_idle fullscreen; border none; max_render_time off
          $important inhibit_idle open; floating enable; border pixel 1
          $max inhibit_idle visible; floating enable; sticky enable; border pixel 1
          $shortcuts floating enable, resize set 2300 1000
          $dialog $float; shadows enable
        }

        for_window {
          [app_id="Sway-Shortcuts"] $shortcuts
          [window_role="pop-up"] $popup
          [window_role="bubble"] $popup
          [window_role="dialog"] $dialog
          [window_type="dialog"] $dialog
        }
      '';
    };

    home.packages = with pkgs; [
      autotiling
      (writeScriptBin
        "swaycheatsheet"
        ''
          #!${runtimeShell}

          ${gnugrep}/bin/grep -E "^bindsym" ~/.config/sway/config | \
            ${gawk}/bin/awk '{$1=""; print $0}' | \
            ${gnused}/bin/sed 's/^ *//g' | \
            ${gnugrep}/bin/grep -vE "^XF86" | \
            ${gnused}/bin/sed -e 's|/nix/store/.*/bin/||g' | \
            ${unixtools.column}/bin/column -t -l2 | \
            ${coreutils}/bin/pr -2 -w 220 -t | \
            ${less}/bin/less
        '')
      (writeScriptBin
        "swaycheatsheet-win"
        ''
          #!${runtimeShell}

          class="Sway-Shortcuts"
          wezterm start --class="$class" swaycheatsheet
        '')
    ];
  };
}
