{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.dunst.custom;
in {
  options.services.dunst.custom = {
    font = mkOption {
      type = types.str;
    };
  };

  config = {
    services.dunst = {
      enable = true;

      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };

      settings = {
        global = {
          monitor = 0;
          follow = "mouse";

          width = 300;
          height = 300;

          origin = "top-right";
          offset = "10x50";
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

          frame_width = 0;
          frame_color = "#282a36";
          separator_color = "frame";

          sort = "yes";

          idle_threshold = 120;

          font = "${cfg.font} 12";

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
        };

        shortcuts = {
          close = "ctrl+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };

        experimental = {
          per_monitor_dpi = "false";
        };

        urgency_low = {
          background = "#282a36";
          foreground = "#6272a4";
          timeout = 10;
        };
        ### Geometry ###

        urgency_normal = {
          background = "#282a36";
          foreground = "#bd93f9";
          timeout = 10;
        };

        urgency_critical = {
          background = "#ff5555";
          foreground = "#f8f8f2";
          frame_color = "#ff5555";
          timeout = 0;
        };
      };
    };
  };
}
