{
  programs.nixvim = {
    plugins = {
      toggleterm.enable = true;
    };

    extraConfigLua =
      # lua
      ''
        function openTerminalPane(file)
          local file_name = file
          if file_name == nil then
            file_name = vim.api.nvim_buf_get_name(0)
          end

          local file_path
          if vim.fn.isdirectory(file_name) ~= 0 then
            file_path = file_name
          else
            file_path = vim.fs.dirname(file_name)
          end

          vim.cmd("ToggleTerm dir=" .. file_path)
        end

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
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
        key = "<leader>tp";
        action = "<cmd>ToggleTerm<cr>";
        options.desc = "Project Directory (ToggleTerm)";
      }
      {
        key = "<leader>tb";
        action.__raw = "function() openTerminalPane() end";
        options.desc = "Current Buffer Directory (ToggleTerm)";
      }
      {
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
