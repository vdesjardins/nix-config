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
        key = "<leader>bp";
        action = "<cmd>Telescope file_browser theme=dropdown hidden=true<cr>";
        options.desc = "Project's Files";
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
    ];
  };
}
