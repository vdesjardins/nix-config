{
  programs.nixvim = {
    plugins = {
      toggleterm.enable = true;

      trim = {
        settings = {
          ft_blocklist = [
            "toggleterm"
          ];
        };
      };
    };

    extraConfigLua =
      # lua
      ''
        require("toggleterm").setup({})

        function openTerminalPane(file, count, name)
          local file_name = file or vim.api.nvim_buf_get_name(0)
          local count = count or 2
          local name = name or "buffer"

          local file_path
          if vim.fn.isdirectory(file_name) ~= 0 then
            file_path = file_name
          else
            file_path = vim.fs.dirname(file_name)
          end

          vim.cmd(count .. "ToggleTerm name=buffer dir=" .. file_path)
        end

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
          display_name = "lazygit",
          float_opts = {
            border = "double",
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(
              term.bufnr,
              "n",
              "q",
              "<cmd>close<CR>",
              { noremap = true, silent = true }
            )
          end,
          -- function to run on closing the terminal
          on_close = function(_term)
            vim.cmd("startinsert!")
          end,
        })

        function lazygit_toggle()
          lazygit:toggle()
        end
      '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>tp";
        action = "<cmd>1ToggleTerm name=project<cr>";
        options.desc = "Project Directory (ToggleTerm)";
      }
      {
        mode = "n";
        key = "<leader>tb";
        action.__raw = "function() openTerminalPane(null, 2, \"buffer\") end";
        options.desc = "Current Buffer Directory (ToggleTerm)";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>TermSelect<cr>";
        options.desc = "Select Terminal (ToggleTerm)";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTermToggleAll<cr>";
        options.desc = "Toggle All Terminals (ToggleTerm)";
      }
      {
        mode = "n";
        key = "<leader>sy";
        action.__raw = "function() lazygit_toggle() end";
        options.desc = "Lazygit (ToggleTerm)";
      }
      {
        mode = "v";
        key = "<leader>s";
        action.__raw =
          # lua
          ''
            function()
              local tsel = "visual_selection"
              if vim.fn.mode():sub(1, 1) == "V" then
                tsel = "visual_lines"
              end
              require("toggleterm").send_lines_to_terminal(tsel, true, { args = vim.v.count })
            end
          '';
        options.desc = "Send Selection Terminal (ToggleTerm)";
      }
    ];
  };
}
