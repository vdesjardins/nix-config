{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      settings = {
        cmdline.view = "cmdline";

        lsp = {
          # override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };

        # you can enable a preset for easier configuration
        presets = {
          bottom_search = true; # use a classic bottom cmdline for search
          command_palette = false; # position the cmdline and popupmenu together
          long_message_to_split = false; # long messages will be sent to a split
          inc_rename = false; # enables an input dialog for inc-rename.nvim
          lsp_doc_border = false; # add a border to hover docs and signature help
        };
      };
    };

    keymaps = [
      {
        mode = ["n" "i" "s"];
        key = "<c-f>";
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end
        '';
        options = {
          silent = true;
          expr = true;
        };
      }
      {
        mode = ["n" "i" "s"];
        key = "<c-b>";
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end'';
        options = {
          silent = true;
          expr = true;
        };
      }
      {
        mode = "c";
        key = "<S-Enter>";
        action.__raw = ''
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end
        '';
        options.desc = "Redirect Cmdline (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nf";
        action = "<cmd>Noice pick<cr>";
        options.desc = "Search (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nl";
        action = "<cmd>Noice last<cr>";
        options.desc = "Last (Noice)";
      }
      {
        mode = "n";
        key = "<leader>ne";
        action = "<cmd>Noice errors<cr>";
        options.desc = "Errors (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nh";
        action = "<cmd>Noice history<cr>";
        options.desc = "History (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nd";
        action = "<cmd>Noice dismiss<cr>";
        options.desc = "Dismiss (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nD";
        action = "<cmd>Noice disable<cr>";
        options.desc = "Disable (Noice)";
      }
      {
        mode = "n";
        key = "<leader>nE";
        action = "<cmd>Noice enable<cr>";
        options.desc = "Enable (Noice)";
      }
    ];
  };
}
