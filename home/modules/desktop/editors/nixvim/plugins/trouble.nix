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

      trim = {
        settings = {
          ft_blocklist = [
            "trouble"
          ];
        };
      };
    };

    keymaps = [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>xs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }
      {
        key = "<leader>xf";
        action = "<cmd>Trouble fzf<cr>";
        options.desc = "Find Results (Trouble)";
      }
      {
        key = "<leader>xF";
        action = "<cmd>Trouble fzf_files<cr>";
        options.desc = "Find Results - Files (Trouble)";
      }
    ];
  };
}
