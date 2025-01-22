{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool int str attrsOf listOf either;

  cfg = config.modules.desktop.extensions.dunst;
in {
  options.modules.desktop.extensions.dunst = {
    enable = mkEnableOption "dunst notifications";

    font = mkOption {
      type = str;
    };

    settings = mkOption {
      type = attrsOf (attrsOf (either str (either bool (either int (listOf str)))));
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      inherit (cfg) enable;

      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };

      settings =
        {
          global = {
            inherit (cfg) font;

            monitor = 0;
            follow = "mouse";

            width = 300;
            height = 300;

            origin = "bottom-right";
            offset = "10x30";
            scale = 0;
            notification_limit = 0;
            progress_bar = "true";

            progress_bar_height = 10;
            progress_bar_frame_width = 1;
            progress_bar_min_width = 150;
            progress_bar_max_width = 300;

            indicate_hidden = "yes";

            transparency = 15;

            separator_height = 1;

            padding = 8;
            horizontal_padding = 10;
            text_icon_padding = 0;

            frame_width = 2;
            separator_color = "frame";

            sort = "yes";

            idle_threshold = 120;

            line_height = 0;

            markup = "full";

            format = "<b>%s %p</b>\\n%b";

            alignment = "left";
            vertical_alignment = "center";

            show_age_threshold = 60;

            ellipsize = "middle";

            ignore_newline = "no";

            stack_duplicates = "true";

            hide_duplicate_count = "false";

            show_indicators = "yes";

            ### Icons ###
            icon_position = "left";
            min_icon_size = 32;
            max_icon_size = 64;
            # Paths to default icons.
            # icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

            ### History ###
            sticky_history = "yes";
            history_length = 20;

            ### Misc/Advanced ###
            dmenu = "rofi -dmenu -p Dunst";
            browser = "xdg-open";

            always_run_script = "true";
            title = "Dunst";
            class = "Dunst";
            corner_radius = 10;
            ignore_dbusclose = "false";
            force_xinerama = "false";

            ### mouse
            mouse_left_click = "close_current";
            mouse_middle_click = "do_action, close_current";
            mouse_right_click = "close_all";

            ### Shortcuts
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            context = "ctrl+shift+period";
          };

          experimental = {
            per_monitor_dpi = "false";
          };
        }
        // cfg.settings;
    };
  };
}
