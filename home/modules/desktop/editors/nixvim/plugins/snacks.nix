{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      snacks = {
        enable = true;

        package = pkgs.vimPlugins.snacks-nvim;

        settings = {
          bufdelete.enable = true;
          bigfile.enable = true;
          notifier.enable = true;
          lazygit.enable = true;
          gitbrowse.enable = true;
          git.enable = true;
          scratch.eanble = true;
          debug.enable = true;
          terminal.enable = true;
          image.enable = true;
          picker = {
            enable = true;
            layout = "vertical";
          };
          input.enable = true;
          explorer.enable = true;
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
                enabled.__raw = ''
                  function()
                    local output = vim.fn.system("jj workspace root --ignore-working-copy")
                    return (Snacks.git.get_root() ~= nil and vim.v.shell_error ~= 0)
                  end
                '';
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
                enabled.__raw = ''
                  function()
                    local output = vim.fn.system("jj workspace root --ignore-working-copy")
                    return (Snacks.git.get_root() ~= nil and vim.v.shell_error == 0)
                  end
                '';
                cmd = "${pkgs.jujutsu}/bin/jj status --no-pager";
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

      trim = {
        settings = {
          ft_blocklist = [
            "snacks_dashboard"
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

      # picker
      {
        mode = "n";
        key = "<leader>bp";
        action.__raw = "function() Snacks.explorer({follow_file = false, auto_close = true}) end";
        options.desc = "Project's File Explorer (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>bb";
        action.__raw = "function() Snacks.explorer({cwd=vim.fn.expand('%:p:h'), follow_file = true, auto_close = true}) end";
        options.desc = "Buffer's File Explorer (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fp";
        action.__raw = "Snacks.picker.projects";
        options.desc = "Projects (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action.__raw = "Snacks.picker.marks";
        options.desc = "Bookmarks (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "Snacks.picker.files";
        options.desc = "Project's Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fF";
        action.__raw = "function() Snacks.picker.files({cwd=vim.fn.expand('%:p:h')}) end";
        options.desc = "Buffer's Directory Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action.__raw = "Snacks.picker.recent";
        options.desc = "Recent Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = "Snacks.picker.resume";
        options.desc = "Resume Last Find (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fM";
        action.__raw = "Snacks.picker.git_status";
        options.desc = "Files Modified (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fH";
        action.__raw = "Snacks.picker.help";
        options.desc = "Help (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action.__raw = "Snacks.picker.grep";
        options.desc = "String in Project (Snacks)";
      }
      # {
      #   mode = "n";
      #   key = "<leader>fg";
      #   action.__raw = "function() Snacks.picker.grep({glob=})";
      #   options.desc = "String and Glob in Project";
      # }
      {
        mode = "n";
        key = "<leader>fS";
        action.__raw = "function() Snacks.picker.grep({cwd=vim.fn.expand('%:~:.:h')}) end";
        options.desc = "String in Buffer's Directory (Snacks)";
      }
      {
        mode = ["n" "x"];
        key = "<leader>fw";
        action.__raw = "function() Snacks.picker.grep_word() end";
        options.desc = "Visual selection or Word in Project's Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>f?";
        action.__raw = "Snacks.picker.search_history";
        options.desc = "Search History (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>f/";
        action.__raw = "function() Snacks.picker.smart() end";
        options.desc = "Smart Search in Project's Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fB";
        action.__raw = "Snacks.picker.pickers";
        options.desc = "Pickers (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action.__raw = "Snacks.picker.buffers";
        options.desc = "Buffers (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>f:";
        action.__raw = "Snacks.picker.commands";
        options.desc = "Commands (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fq";
        action.__raw = "Snacks.picker.command_history";
        options.desc = "Commands History (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fk";
        action.__raw = "Snacks.picker.keymaps";
        options.desc = "Keymaps (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>fy";
        action.__raw = "Snacks.picker.cliphist";
        options.desc = "Clipboard History (Snacks)";
      }

      # git
      {
        mode = "n";
        key = "<leader>sB";
        action.__raw = "Snacks.picker.git_branches";
        options.desc = "Git Branches (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>sC";
        action.__raw = "Snacks.picker.git_log_file";
        options.desc = "Buffer's Git Commits (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>sl";
        action.__raw = "Snacks.picker.git_log_line";
        options.desc = "Line's Git Commits (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>sL";
        action.__raw = "Snacks.picker.git_log";
        options.desc = "Git Commits (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = "Snacks.picker.git_status";
        options.desc = "Git Status (Snacks)";
      }

      # make targets
      {
        mode = "n";
        key = "<leader><space>m";
        action.__raw = ''
          function()
            M = {}
            function M.finder(opts)
              return require("snacks.picker.source.proc").proc(vim.tbl_deep_extend("force", {
                cmd = "sed",
                args = { "-n", "s/^##//p", "Makefile" },
                ---@param item snacks.picker.finder.Item
                transform = function(item)
                  local target, desc = item.text:match("^%s*(%S+):%s+(.+)$")
                  if target and desc then
                    item.target = target
                    item.desc = desc
                  else
                    return false
                  end
                end,
              }, opts or {}))
            end

            function M.format(item, picker)
              local ret = {} ---@type snacks.picker.Highlight[]
              ret[#ret + 1] = { Snacks.picker.util.align(tostring(item.target), 20), "SnacksPickerBufNr" }
              ret[#ret + 1] = { " " }
              ret[#ret + 1] = { item.desc }
              return ret
            end

            require("snacks.picker").pick({
              layout = "select",
              finder = M.finder,
              format = M.format,
              confirm = function(picker, item)
                picker:close()
                Snacks.terminal("make " .. item.target)
              end,
            })
          end
        '';
        options.desc = "Make Targets (Snacks)";
      }
    ];

    extraPackages = with pkgs; [
      imagemagick
    ];
  };
}
