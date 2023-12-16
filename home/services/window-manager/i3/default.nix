{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  mod = "Mod4";

  wallpaperName = "wallhaven-wq1wlr.jpg";
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/wq/wallhaven-wq1wlr.jpg";
    hash = "sha256-FcBT/iyL9erjyk+iZ6b1OLJ+lB7N5IUVXWdMxmmUnDk=";
  };

  locker = "${pkgs.i3lock-pixeled}/bin/i3lock-pixeled";
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

  cfg = config.xsession.windowManager.i3.custom;
in {
  options.xsession.windowManager.i3.custom = {
    font = mkOption {
      type = types.str;
    };
  };

  config = {
    home.packages = with pkgs; [
      autotiling
      (writeScriptBin
        "i3cheatsheet"
        ''
          #!${runtimeShell}

          ${gnugrep}/bin/grep -E "^bindsym" ~/.config/i3/config | ${gawk}/bin/awk '{$1=""; print $0}' | ${gnused}/bin/sed 's/^ *//g' | ${gnugrep}/bin/grep -vE "^XF86" | ${unixtools.column}/bin/column | ${coreutils}/bin/pr -2 -w 160 -t | ${less}/bin/less
        '')
      (writeScriptBin
        "i3cheatsheet-win"
        ''
          #!${runtimeShell}

          ${terminal} start --always-new-process --no-auto-connect -- i3cheatsheet
        '')
      (writeScriptBin
        "i3-warp-mouse"
        ''
          #!${runtimeShell}

          XDT="${xdotool}/bin/xdotool"

          WINDOW=$("$XDT" getwindowfocus)

          # this brings in variables WIDTH and HEIGHT
          eval $("$XDT" getwindowgeometry --shell "$WINDOW")

          TX=$(expr "$WIDTH" / 2)
          TY=$(expr "$HEIGHT" / 2)

          "$XDT" mousemove -window "$WINDOW" "$TX" "$TY"
        '')
    ];

    gtk = {
      enable = true;
      font = {
        name = cfg.font;
        size = 10;
      };
    };

    xsession = {
      enable = true;

      initExtra = ''
        xset r rate 200 30
        export TERMINAL="${terminal}"
      '';

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = {
          modifier = mod;
          defaultWorkspace = "workspace ${ws1}";

          workspaceAutoBackAndForth = true;

          menu = "rofi -show drun";

          focus = {
            followMouse = true;
            mouseWarping = true;
          };

          bars = [
            {
              colors = {
                background = "#1c1c22";
                focusedWorkspace = {
                  border = "#7592af";
                  background = "#2e3440";
                  text = "#ffffff";
                };
              };

              fonts = {
                names = [cfg.font];
                size = 12.0;
              };

              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
            }
          ];

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
            "${mod}+h" = "focus left, exec i3-warp-mouse";
            "${mod}+j" = "focus down, exec i3-warp-mouse";
            "${mod}+k" = "focus up, exec i3-warp-mouse";
            "${mod}+l" = "focus right, exec i3-warp-mouse";

            "${mod}+g" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";

            # Move
            "${mod}+Shift+h" = "move left, exec i3-warp-mouse";
            "${mod}+Shift+j" = "move down, exec i3-warp-mouse";
            "${mod}+Shift+k" = "move up, exec i3-warp-mouse";
            "${mod}+Shift+l" = "move right, exec i3-warp-mouse";

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
            "${mod}+f" = "fullscreen, exec i3-warp-mouse";

            # start a terminal
            "${mod}+Return" = "exec ${terminal}, exec i3-warp-mouse";

            # lock screen
            "${mod}+Shift+x" = "exec --no-startup-id ${locker}";

            # toggle tiling / floating
            "${mod}+Shift+space" = "floating toggle";

            # move the currently focused window to the scratchpad
            "${mod}+Shift+minus" = "move scratchpad";

            # Show the next scratchpad window or hide the focused scratchpad window.
            # If there are multiple scratchpad windows, this command cycles through them.
            "${mod}+minus" = "scratchpad show";

            # Multimedia Key Controls from https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759
            # Pulse Audio controls
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%"; #increase sound volume
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%"; #decrease sound volume
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle"; # mute sound

            # Sreen brightness controls
            "XF86MonBrightnessUp" = "exec brightnessctl set +50"; # increase screen brightness
            "XF86MonBrightnessDown" = "exec brightnessctl set 50-"; # decrease screen brightness

            # Media player controls
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";

            # Screenshots
            "${mod}+p" = "exec --no-startup-id flameshot gui";
            "${mod}+Shift+p" = "exec --no-startup-id flameshot full --clipboard --path ~/Pictures/Flameshot/";

            # clipboard
            "${mod}+Shift+c" = ''exec "rofi -modi 'clipboard:greenclip print' -show clipboard"'';

            # Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps.
            # Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace).
            # If you also press Shift with these keys, the change will be global for all workspaces.
            "${mod}+Shift+g" = "mode \"${modeGaps}\"";

            # Rofi window switcher
            "${mod}+Shift+d" = "exec rofi -show window";

            # Rofi combi switcher
            "${mod}+Shift+o" = "exec rofi -show combi";

            # Launch Browser
            "${mod}+b" = "exec firefox, exec i3-warp-mouse";

            # rename current workspace
            "${mod}+comma" = "exec i3-input -F 'rename workspace to \"%s \"' -P 'New name for this workspace: '";
            # rename current window
            "${mod}+period" = "exec i3-input -F 'exec i3-msg title_format \"%s \"' -P 'New name for this window: '";
            # kill app
            "${mod}+Shift+q" = "kill";

            # Enable/disable logging
            "${mod}+x" = "shmlog toggle";

            # quick shortcut help
            "${mod}+Shift+question" = "exec --no-startup-id i3cheatsheet-win";
          };

          modes = lib.mkOptionDefault {
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
          };

          startup = [
            {
              command = "imv ~/.config/wallpapers/${wallpaperName}";
            }
            {
              command = "i3-sensible-terminal";
            }
            {
              command = "autotiling";
              notification = false;
              always = true;
            }
          ];
        };

        extraConfig = ''
          # quick shortcut help
          for_window [title=" i3 Shortcuts "] floating enable, move absolute position center, resize grow left 318, resize grow right 318, resize grow down 115, resize grow up 115
          # warp mouse to window
          for_window [class=.*] exec i3-warp-mouse
        '';
      };
    };
  };
}
