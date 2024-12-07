{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];

          set_env.COLORTERM = "truecolor";
        };
        pickers = {
          live_grep = {
            theme = "dropdown";
            additional_args.__raw = ''
              function()
                return { "--hidden" }
              end
            '';
          };
          marks = {
            theme = "dropdown";
          };
          file_browser = {
            theme = "dropdown";
          };
          find_files = {
            theme = "dropdown";
          };
          help_tags = {
            theme = "dropdown";
          };
          builtin = {
            theme = "dropdown";
          };
          buffers = {
            theme = "dropdown";
          };
          commands = {
            theme = "dropdown";
          };
          keymaps = {
            theme = "dropdown";
          };
          manix = {
            theme = "dropdown";
          };
        };
      };
      extensions = {
        ui-select.enable = true;
        frecency = {
          enable = true;
          settings = {
            show_scores = true;
          };
        };
        file-browser = {
          enable = true;
          settings = {
            cwd_to_path = true;
            hijack_netrw = true;
          };
        };
        manix = {
          enable = true;
        };
        fzf-native = {
          enable = true;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>bb";
        action = "<cmd>Telescope file_browser theme=dropdown path=%:p:h |select_buffer=true| hidden=true<CR>";
        options.desc = "Buffer's Directory Files";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>Telescope marks<cr>";
        options.desc = "Bookmarks";
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>Telescope file_browser theme=dropdown hidden=true<cr>";
        options.desc = "Project's Files";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files hidden=true<cr>";
        options.desc = "Project's Files";
      }
      {
        mode = "n";
        key = "<leader>fF";
        action.__raw = ''
          function()
            local file_path = vim.fn.expand("%:~:.:h")

            require("telescope.builtin").find_files({
              search_dirs = {file_path},
              prompt_title = string.format("Find Files in [%s]", file_path),
            })
          end
        '';
        options.desc = "Buffer's Directory Files";
      }
      {
        mode = "n";
        key = "<leader>fH";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help Tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<cr>";
        options.desc = "Frecency";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "String in Project";
      }
      {
        mode = "n";
        key = "<leader>fS";
        action.__raw = ''
          function()
            local file_path = vim.fn.expand("%:~:.:h")

            require("telescope.builtin").live_grep({
              search_dirs = {file_path},
              prompt_title = string.format("Grep in [%s]", file_path),
            })
          end
        '';
        options.desc = "String in Buffer's Directory";
      }
      {
        mode = "n";
        key = "<leader>fT";
        action = "<cmd>Telescope builtin<cr>";
        options.desc = "Telescope";
      }
      {
        mode = "n";
        key = "<leader>fn";
        action = "<cmd>Telescope manix<cr>";
        options = {
          silent = true;
          desc = "Manix";
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>f:";
        action = "<cmd>Telescope commands<cr>";
        options.desc = "Commands";
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>Telescope keymaps<cr>";
        options.desc = "Keymaps";
      }
    ];
  };
}
