{
  programs.nixvim = {
    plugins = {
      trouble = {
        enable = true;

        settings = {
          modes = {
            preview_split = {
              mode = "diagnostics";
              preview = {
                type = "split";
                relative = "win";
                position = "right";
                size = 0.5;
              };
            };
            preview_float = {
              mode = "diagnostics";
              preview = {
                type = "float";
                relative = "editor";
                border = "rounded";
                title = "Preview";
                title_pos = "center";
                position = [0 (-2)];
                size = {
                  width = 0.3;
                  height = 0.3;
                };
                zindex = 200;
              };
            };
          };
        };
      };

      telescope = {
        settings = {
          defaults = {
            mappings = {
              i = {
                "<c-t>".__raw = ''
                  require("trouble.sources.telescope").open
                '';
              };
              n = {
                "<c-t>".__raw = ''
                  require("trouble.sources.telescope").open
                '';
              };
            };
          };
        };
      };

      trim = {
        settings = {
          highlight = true;
          ft_blocklist = [
            "trouble"
          ];
        };
      };
    };

    keymaps = [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble preview_float diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble preview_float diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>xs";
        action = "<cmd>Trouble preview_float symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble preview_float lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble preview_float loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble preview_float qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }
    ];
  };
}
