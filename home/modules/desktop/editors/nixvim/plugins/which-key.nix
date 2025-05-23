{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      spelling = {
        enabled = true;
      };
      win = {
        border = "single";
      };

      spec = [
        {
          __unkeyed-1 = "<leader>B";
          group = "Buffers";
        }
        {
          __unkeyed-2 = "<leader>b";
          group = "Browse";
        }
        {
          __unkeyed-3 = "<leader>g";
          group = "Goto";
        }
        {
          __unkeyed-4 = "<leader>s";
          group = "SCM";
        }
        {
          __unkeyed-5 = "<leader>t";
          group = "Terminal";
        }
        {
          __unkeyed-6 = "<leader>T";
          group = "Todos";
        }
        {
          __unkeyed-7 = "<leader>d";
          group = "Debug";
        }
        {
          __unkeyed-8 = "<leader>dl";
          group = "Logging";
        }
        {
          __unkeyed-9 = "<leader>dd";
          group = "Debugger";
        }
        {
          __unkeyed-10 = "<leader>h";
          group = "Help";
        }
        {
          __unkeyed-11 = "<leader>f";
          group = "Find";
          mode = ["n" "v"];
        }
        {
          __unkeyed-12 = "<leader>x";
          group = "Diagnostics";
          mode = ["n" "v"];
        }
        {
          __unkeyed-13 = "<leader>l";
          group = "Language Tools";
          mode = ["n" "v"];
        }
        {
          __unkeyed-14 = "<leader>c";
          group = "Chat / AI";
          mode = ["n" "v"];
        }
        {
          __unkeyed-15 = "<leader><space>";
          group = "Execute";
          mode = ["n" "v"];
        }
        {
          __unkeyed-16 = "<leader>lx";
          group = "LSP Logging";
        }
        {
          __unkeyed-17 = "<leader>n";
          group = "Notifications";
        }
        {
          __unkeyed-18 = "<leader>m";
          group = "Misc";
        }
        {
          __unkeyed-19 = "<leader>r";
          group = "Requests";
        }
      ];
    };
  };
}
