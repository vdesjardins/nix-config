{pkgs, ...}: {
  programs.nixvim = {
    plugins.snacks = {
      enable = true;

      settings = {
        bufdelete.enable = true;
        bigfile.enable = true;
        notifier.enable = true;
        lazygit.enable = true;
        gitbrowse.enable = true;
        git.enable = true;
        scratch.eanble = true;
        debug.enable = true;
        dashboard = {
          enable = true;
          preset = {
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "s";
                desc = "Restore Session";
                section = "session";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };
          sections = [
            {
              section = "header";
            }
            {
              pane = 2;
              section = "terminal";
              cmd = "${pkgs.dwt1-shell-color-scripts}/bin/colorscript -e square";
              height = 5;
              padding = 1;
            }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              indent = 2;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Projects";
              section = "projects";
              indent = 2;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Git Status";
              section = "terminal";
              enabled.__raw = "function() return (Snacks.git.get_root() ~= nil and vim.fn.isdirectory(Snacks.git.get_root() .. '/.jj') == false) end";
              cmd = "${pkgs.hub}/bin/hub status --short --branch --renames";
              height = 10;
              padding = 1;
              ttl = 5 * 60;
              indent = 3;
            }
            {
              pane = 2;
              icon = " ";
              title = "Jujutsu Status";
              section = "terminal";
              enabled.__raw = "function() return (Snacks.git.get_root() ~= nil and vim.fn.isdirectory(Snacks.git.get_root() .. '/.jj')) end";
              cmd = "${pkgs.jujutsu}/bin/jj status";
              height = 10;
              padding = 1;
              ttl = 5 * 60;
              indent = 3;
            }
            {
              section = "startup";
              enabled = false;
            }
          ];
        };
      };
    };

    extraConfigLuaPre = ''
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>sy";
        action.__raw = "Snacks.lazygit.open";
        options.desc = "Lazygit (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action.__raw = "Snacks.git.blame_line";
        options.desc = "Blame Line (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>sB";
        action.__raw = "Snacks.gitbrowse.open";
        options.desc = "Open in Browser (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>B.";
        action.__raw = "function() Snacks.scratch() end";
        options.desc = "Toggle Scratch Buffer (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>BS";
        action.__raw = "Snacks.scratch.select";
        options.desc = "Select Scratch Buffer (Snacks)";
      }
    ];
  };
}
