{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        icons = {};
        files = {
          options = {
            use_as_default_explorer = false;
          };
        };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>bP";
        action.__raw = ''
          function()
            MiniFiles.open()
          end
        '';
        options.desc = "Browse project's files (Mini)";
      }
      {
        mode = "n";
        key = "<leader>bB";
        action.__raw = ''
          function()
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          end
        '';
        options.desc = "Browse buffer's files (Mini)";
      }
    ];
  };
}
