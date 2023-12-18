{pkgs, ...}: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        theme = "ctp-mocha";
        icons = "awesome6";

        blocks = [
          {
            block = "music";
            format = " $icon {$combo.str(max_w:25,rot_interval:0.5) $prev $play $next |}";
          }
          {
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            format = "$icon root: $available.eng(w:2)";
          }
          {
            block = "memory";
            format = "$icon $mem_total_used_percents.eng(w:2)";
            format_alt = "$icon_swap $swap_used_percents.eng(w:2)";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = "$icon $1m";
            interval = 1;
          }
          {
            block = "keyboard_layout";
            interval = 2;
          }
          {
            block = "sound";
            step_width = 2;
          }
          {
            block = "time";
            format = "UTC $timestamp.datetime(f:'%H')";
            timezone = "Etc/UTC";
            interval = 1;
          }
          {
            block = "time";
            format = "$icon $timestamp.datetime(f:'%a %d/%m %R')";
            interval = 1;
          }
        ];
      };
    };
  };
}
