{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.darwin.aerospace;
in {
  options.modules.darwin.aerospace = {
    enable = mkEnableOption "aerospace";
  };

  config = mkIf cfg.enable {
    programs.aerospace = {
      inherit (cfg) enable;

      launchd.enable = true;

      settings = {
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        key-mapping.preset = "qwerty";

        after-startup-command = [
          ''exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xffa6a6a6 inactive_color=0x00a6a6a6 style=round width=5.0''
        ];

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
        };

        on-focused-monitor-changed = [];
        on-focus-changed = ["move-mouse window-lazy-center"];

        mode.main.binding = {
          # focus
          cmd-h = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors left";
          cmd-j = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors down";
          cmd-k = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors up";
          cmd-l = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors right";

          # focus previous
          cmd-alt-tab = "focus-back-and-forth";

          # move window
          cmd-shift-h = "move left";
          cmd-shift-j = "move down";
          cmd-shift-k = "move up";
          cmd-shift-l = "move right";

          # change layout
          cmd-shift-s = "layout v_accordion"; # 'layout stacking' in i3
          cmd-shift-w = "layout h_accordion"; # 'layout tabbed' in i3
          cmd-shift-e = "layout tiles horizontal vertical"; # 'layout toggle split' in i3

          cmd-shift-space = "layout floating tiling"; # 'floating toggle' in i3

          # fullscreen
          cmd-f = "fullscreen";

          # focus workspace
          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          cmd-5 = "workspace 5";
          cmd-6 = "workspace 6";
          cmd-7 = "workspace 7";
          cmd-8 = "workspace 8";
          cmd-9 = "workspace 9";
          cmd-0 = "workspace 10";

          # move window to workspace
          cmd-shift-1 = "move-node-to-workspace 1";
          cmd-shift-2 = "move-node-to-workspace 2";
          cmd-shift-3 = "move-node-to-workspace 3";
          cmd-shift-4 = "move-node-to-workspace 4";
          cmd-shift-5 = "move-node-to-workspace 5";
          cmd-shift-6 = "move-node-to-workspace 6";
          cmd-shift-7 = "move-node-to-workspace 7";
          cmd-shift-8 = "move-node-to-workspace 8";
          cmd-shift-9 = "move-node-to-workspace 9";
          cmd-shift-0 = "move-node-to-workspace 10";

          cmd-shift-r = "reload-config";

          cmd-r = "mode resize";
        };

        mode.resize.binding = {
          h = "resize width -20";
          j = "resize height +20";
          k = "resize height -20";
          l = "resize width +20";
          shift-h = "resize width -5";
          shift-j = "resize height +5";
          shift-k = "resize height -5";
          shift-l = "resize width +5";
          enter = "mode main";
          esc = "mode main";
        };

        workspace-to-monitor-force-assignment = {
          "1" = ["secondary" "main"];
          "2" = ["secondary" "main"];
          "3" = ["secondary" "main"];
          "4" = ["secondary" "main"];
          "5" = ["secondary" "main"];
          "6" = "main";
          "7" = "main";
          "8" = "main";
          "9" = "main";
          "10" = "main";
        };

        on-window-detected = [
          {
            "if" = {
              app-id = "org.mozilla.firefox";
              window-title-regex-substring = "Picture-in-Picture";
            };
            run = ["layout floating"];
          }
          {
            "if" = {
              app-id = "com.google.Chrome";
              window-title-regex-substring = "Picture in Picture";
            };
            run = "layout floating";
            check-further-callbacks = true;
          }
        ];
      };
    };
  };
}
