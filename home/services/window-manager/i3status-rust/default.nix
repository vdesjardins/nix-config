{pkgs, ...}: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        theme = "nord-dark";
        icons = "awesome5";

        blocks = [
          {
            block = "disk_space";
            alert = 10;
            alias = "/";
            info_type = "available";
            interval = 60;
            path = "/";
            unit = "GB";
            warning = 20;
          }
          {
            block = "memory";
            format_mem = "{mem_used;G}";
            format_swap = "{swap_used;G}";
            warning_mem = 90;
            warning_swap = 90;
            critical_mem = 95;
            critical_swap = 95;
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = "{1m}";
            interval = 1;
          }
          # {
          #   block = "sound";
          #   step_width = 2;
          # }
          {
            block = "time";
            format = "UTC %H";
            timezone = "Etc/UTC";
            interval = 1;
          }
          {
            block = "time";
            format = "%F %R:%S";
            interval = 1;
          }
        ];
      };
    };
  };
}
