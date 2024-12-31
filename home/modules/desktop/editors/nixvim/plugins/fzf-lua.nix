{
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      profile = "fzf-native";
      settings = {
        winopts = {
          preview = {
            layout = "vertical";
          };
        };
        previewers = {
          builtin = {
            syntax_limit_b = 1024 * 100;
          };
        };
        oldfiles = {
          include_current_session = true;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>FzfLua marks<cr>";
        options.desc = "Bookmarks";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<cr>";
        options.desc = "Project's Files";
      }
      {
        mode = "n";
        key = "<leader>fF";
        action = "<cmd>FzfLua files cwd=%:p:h<cr>";
        options.desc = "Buffer's Directory Files";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>FzfLua oldfiles<cr>";
        options.desc = "Recent Files";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>FzfLua resume<cr>";
        options.desc = "Resume Last Find";
      }
      {
        mode = "n";
        key = "<leader>fM";
        action = "<cmd>FzfLua git_status<cr>";
        options.desc = "Files Modified";
      }
      {
        mode = "n";
        key = "<leader>fH";
        action = "<cmd>FzfLua helptags<cr>";
        options.desc = "Help Tags";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<cmd>FzfLua live_grep_native<cr>";
        options.desc = "String in Project";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep_glob<cr>";
        options.desc = "String and Glob in Project";
      }
      {
        mode = "n";
        key = "<leader>fS";
        action = "<cmd>FzfLua live_grep_native cwd=%:~:.:h<cr>";
        options.desc = "String in Buffer's Directory";
      }
      {
        mode = "n";
        key = "<leader>fB";
        action = "<cmd>FzfLua builtin<cr>";
        options.desc = "Builtin";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>FzfLua buffers<cr>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>f:";
        action = "<cmd>FzfLua commands<cr>";
        options.desc = "Commands";
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>FzfLua keymaps<cr>";
        options.desc = "Keymaps";
      }

      # git
      {
        mode = "n";
        key = "<leader>sC";
        action = "<cmd>FzfLua git_bcommits<cr>";
        options.desc = "Buffer's Git Commits";
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>FzfLua git_commits<cr>";
        options.desc = "Buffer's Git Commits";
      }

      # make targets
      {
        mode = "n";
        key = "<leader><space>m";
        action.__raw = ''
          function()
            require("fzf-lua").fzf_exec(
                "sed -n 's/^##//p' Makefile | column -t -s ':' |  sed -e 's/^/ /'",
              {
                prompt = "Make Targets> ",
                actions = {
                  ['default'] = function(selected)
                    local target = vim.split(selected[1], " ", {trimempty = true})[1]
                    Snacks.terminal("make " .. target)
                  end
                }
              }
            )
          end
        '';
        options.desc = "Make Targets";
      }
    ];
  };
}
