{
  programs.nixvim = {
    plugins.oil = {
      enable = true;

      settings = {
        float = {
          preview_split = "below";
        };

        keymaps = {
          "q" = "actions.close";
          "y." = "actions.copy_entry_path";
        };

        view_options = {
          show_hidden = true;
        };

        win_options = {
          concealcursor = "ncv";
          conceallevel = 3;
          cursorcolumn = false;
          foldcolumn = "0";
          list = false;
          signcolumn = "no";
          spell = false;
          wrap = false;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>bo";
        action.__raw = ''
          function()
            local oil = require("oil")
            local util = require("oil.util")

            oil.open_float(vim.fs.root(0, {".git", ".jj"}))
            util.run_after_load(0, function()
              oil.open_preview()
            end)
          end
        '';
        options.desc = "Browse project's files (Oil)";
      }
      {
        mode = "n";
        key = "<leader>bO";
        action.__raw = ''
          function()
            local oil = require("oil")
            local util = require("oil.util")
            oil.open_float()
            util.run_after_load(0, function()
              oil.open_preview()
            end)
          end
        '';
        options.desc = "Browse buffer's files (Oil)";
      }
    ];
  };
}
