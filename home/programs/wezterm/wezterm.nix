{
  key_leader ? "`",
  mods_leader ? "",
  homeDirectory,
}: ''
  local wezterm = require("wezterm")

  local config = {
      check_for_updates = false,
      font = wezterm.font("Monaspace Krypton"),
      color_scheme = 'nord',
      tab_bar_at_bottom = true,
      inactive_pane_hsb = { hue = 1.0, saturation = 0.5, brightness = 1.0 },
      exit_behavior = "Close",
      leader = { key = "${key_leader}", mods = "${mods_leader}" },

      mouse_bindings = {
          {
              event = { Down = { streak = 3, button = "Left" } },
              action = { SelectTextAtMouseCursor = "SemanticZone" },
              mods = "NONE",
          },
      },

      pane_focus_follows_mouse = true,

      keys = {
          -- panes
          { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
          {
              key = "s",
              mods = "LEADER",
              action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
          },
          {
              key = "v",
              mods = "LEADER",
              action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
          },
          {
              key = "h",
              mods = "LEADER",
              action = wezterm.action({ ActivatePaneDirection = "Left" }),
          },
          {
              key = "j",
              mods = "LEADER",
              action = wezterm.action({ ActivatePaneDirection = "Down" }),
          },
          { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
          {
              key = "l",
              mods = "LEADER",
              action = wezterm.action({ ActivatePaneDirection = "Right" }),
          },
          { key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
          { key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
          { key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
          {
              key = "l",
              mods = "CTRL",
              action = wezterm.action({ ActivatePaneDirection = "Right" }),
          },
          {
              key = "H",
              mods = "LEADER|SHIFT",
              action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }),
          },
          {
              key = "J",
              mods = "LEADER|SHIFT",
              action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }),
          },
          {
              key = "K",
              mods = "LEADER|SHIFT",
              action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }),
          },
          {
              key = "L",
              mods = "LEADER|SHIFT",
              action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }),
          },
          {
              key = "x",
              mods = "LEADER",
              action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
          },

          -- tabs
          {
              key = "c",
              mods = "LEADER",
              action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
          },
          { key = "b", mods = "LEADER", action = "ActivateLastTab" },
          { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
          { key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
          { key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
          { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
          { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
          { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
          { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
          { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
          { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
          { key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
          { key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
          { key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
          {
              key = "&",
              mods = "LEADER|SHIFT",
              action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
          },

          -- utils
          { key = "`", mods = "LEADER", action = wezterm.action({ SendString = "`" }) },
          {
              key = "~",
              mods = "LEADER|SHIFT",
              action = wezterm.action({
                  SplitVertical = {
                      domain = "CurrentPaneDomain",
                      args = { "${homeDirectory}/.nix-profile/bin/htop" },
                  },
              }),
          },
          { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
          {
              key = "l",
              mods = "CTRL",
              action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }),
          },
          { key = "[", mods = "LEADER", action = "ActivateCopyMode" },
          { key = "E", mods = "LEADER", action = wezterm.action({ EmitEvent = "open-in-vim" }) },
          {
              key = "]",
              mods = "LEADER",
              action = wezterm.action({ PasteFrom = "PrimarySelection" }),
          },

          -- selection
          { key = "S", mods = "LEADER|SHIFT", action = "QuickSelect" },
      },

      key_tables = {
          copy_mode = {
              { key = "c", mods = "CTRL", action = wezterm.action({ CopyMode = "Close" }) },
              { key = "g", mods = "CTRL", action = wezterm.action({ CopyMode = "Close" }) },
              { key = "q", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
              { key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },

              { key = "h", mods = "NONE", action = wezterm.action({ CopyMode = "MoveLeft" }) },
              { key = "j", mods = "NONE", action = wezterm.action({ CopyMode = "MoveDown" }) },
              { key = "k", mods = "NONE", action = wezterm.action({ CopyMode = "MoveUp" }) },
              { key = "l", mods = "NONE", action = wezterm.action({ CopyMode = "MoveRight" }) },

              {
                  key = "LeftArrow",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveLeft" }),
              },
              {
                  key = "DownArrow",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveDown" }),
              },
              { key = "UpArrow", mods = "NONE", action = wezterm.action({ CopyMode = "MoveUp" }) },
              {
                  key = "RightArrow",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveRight" }),
              },

              {
                  key = "RightArrow",
                  mods = "ALT",
                  action = wezterm.action({
                      CopyMode = "MoveForwardWord",
                  }),
              },
              {
                  key = "f",
                  mods = "ALT",
                  action = wezterm.action({ CopyMode = "MoveForwardWord" }),
              },
              {
                  key = "Tab",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveForwardWord" }),
              },
              {
                  key = "w",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveForwardWord" }),
              },

              {
                  key = "LeftArrow",
                  mods = "ALT",
                  action = wezterm.action({
                      CopyMode = "MoveBackwardWord",
                  }),
              },
              {
                  key = "b",
                  mods = "ALT",
                  action = wezterm.action({ CopyMode = "MoveBackwardWord" }),
              },
              {
                  key = "Tab",
                  mods = "SHIFT",
                  action = wezterm.action({ CopyMode = "MoveBackwardWord" }),
              },
              {
                  key = "b",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveBackwardWord" }),
              },

              {
                  key = "0",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveToStartOfLine" }),
              },
              {
                  key = "Enter",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "MoveToStartOfNextLine",
                  }),
              },
              {
                  key = "$",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "MoveToEndOfLineContent",
                  }),
              },
              {
                  key = "$",
                  mods = "SHIFT",
                  action = wezterm.action({
                      CopyMode = "MoveToEndOfLineContent",
                  }),
              },

              {
                  key = "m",
                  mods = "ALT",
                  action = wezterm.action({
                      CopyMode = "MoveToStartOfLineContent",
                  }),
              },
              {
                  key = "^",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "MoveToStartOfLineContent",
                  }),
              },
              {
                  key = "^",
                  mods = "SHIFT",
                  action = wezterm.action({
                      CopyMode = "MoveToStartOfLineContent",
                  }),
              },

              {
                  key = " ",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "ToggleSelectionByCell",
                  }),
              },
              {
                  key = "v",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "ToggleSelectionByCell",
                  }),
              },
              {
                  key = "v",
                  mods = "CTRL",
                  action = wezterm.action({
                      CopyMode = { SetSelectionMode = "Block" },
                  }),
              },
              {
                  key = "y",
                  mods = "NONE",
                  action = wezterm.action({
                      Multiple = {
                          wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
                          wezterm.action({ CopyMode = "Close" }),
                      },
                  }),
              },
              {
                  key = "G",
                  mods = "NONE",
                  action = wezterm.action({
                      CopyMode = "MoveToScrollbackBottom",
                  }),
              },
              {
                  key = "G",
                  mods = "SHIFT",
                  action = wezterm.action({
                      CopyMode = "MoveToScrollbackBottom",
                  }),
              },
              {
                  key = "g",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveToScrollbackTop" }),
              },

              {
                  key = "H",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveToViewportTop" }),
              },
              {
                  key = "H",
                  mods = "SHIFT",
                  action = wezterm.action({ CopyMode = "MoveToViewportTop" }),
              },
              {
                  key = "M",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveToViewportMiddle" }),
              },
              {
                  key = "M",
                  mods = "SHIFT",
                  action = wezterm.action({
                      CopyMode = "MoveToViewportMiddle",
                  }),
              },
              {
                  key = "L",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "MoveToViewportBottom" }),
              },
              {
                  key = "L",
                  mods = "SHIFT",
                  action = wezterm.action({
                      CopyMode = "MoveToViewportBottom",
                  }),
              },

              { key = "PageUp", mods = "NONE", action = wezterm.action({ CopyMode = "PageUp" }) },
              {
                  key = "PageDown",
                  mods = "NONE",
                  action = wezterm.action({ CopyMode = "PageDown" }),
              },

              { key = "b", mods = "CTRL", action = wezterm.action({ CopyMode = "PageUp" }) },
              { key = "f", mods = "CTRL", action = wezterm.action({ CopyMode = "PageDown" }) },
              -- Enter search mode to edit the pattern.
              -- When the search pattern is an empty string the existing pattern is preserved
              {
                  key = "?",
                  mods = "NONE",
                  action = wezterm.action({
                      Search = {
                          CaseSensitiveString = "",
                      },
                  }),
              },
              -- navigate any search mode results
              { key = "N", mods = "NONE", action = wezterm.action({ CopyMode = "NextMatch" }) },
              { key = "n", mods = "SHIFT", action = wezterm.action({ CopyMode = "PriorMatch" }) },
          },
          search_mode = {
              { key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
              -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
              -- to navigate search results without conflicting with typing into the search area.
              { key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
          },
      },
  }

  wezterm.on("update-right-status", function(window, pane)
      -- Each element holds the text for a cell in a "powerline" style << fade
      local cells = {}

      -- Figure out the cwd and host of the current pane.
      -- This will pick up the hostname for the remote host if your
      -- shell is using OSC 7 on the remote host.
      local cwd_uri = pane:get_current_working_dir()
      if cwd_uri then
          cwd_uri = cwd_uri:sub(8)
          local slash = cwd_uri:find("/")
          if slash then
              local hostname = cwd_uri:sub(1, slash - 1)
              -- Remove the domain name portion of the hostname
              local dot = hostname:find("[.]")
              if dot then
                  hostname = hostname:sub(1, dot - 1)
              end
              -- and extract the cwd from the uri
              -- cwd = cwd_uri:sub(slash)

              -- table.insert(cells, cwd);
              table.insert(cells, hostname)
          end
      end

      local date = wezterm.strftime("📆 %a %b %-d %H:%M")
      table.insert(cells, date)

      -- An entry for each battery (typically 0 or 1 battery)
      for _, b in ipairs(wezterm.battery_info()) do
          table.insert(cells, string.format("🔋%.0f%% ", b.state_of_charge * 100))
      end

      -- The filled in variant of the < symbol
      local SOLID_LEFT_ARROW = ""

      -- Color palette for the backgrounds of each cell
      local colors = { "#3b4252", "#88c0d0", "#81a1c1" }

      -- Foreground color for the text across the fade
      local text_colors = { "#d2d6df", "#505e72", "#505e72"}

      -- The elements to be formatted
      local elements = {}
      -- How many cells have been formatted
      local num_cells = 0

      -- Translate a cell into elements
      local function push(text)
          local cell_no = num_cells + 1
          table.insert(elements, { Foreground = { Color = colors[cell_no] } })
          table.insert(elements, { Text = SOLID_LEFT_ARROW })
          table.insert(elements, { Foreground = { Color = text_colors[cell_no] } })
          table.insert(elements, { Background = { Color = colors[cell_no] } })
          table.insert(elements, { Text = " " .. text .. " " })
          num_cells = num_cells + 1
      end

      while #cells > 0 do
          local cell = table.remove(cells, 1)
          push(cell)
      end

      window:set_right_status(wezterm.format(elements))
  end)

  wezterm.on("open-in-vim", function(window, pane)
      local filename = os.tmpname() .. "_hist"
      local file = io.open(filename, "w")
      file:write(pane:get_logical_lines_as_text(3000))
      file:close()

      window:perform_action(
          wezterm.action({
              SendString = "nvim " .. filename .. " -c 'call cursor(3000,0)'\n",
          }),
          pane
      )
  end)

  wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
      if tab.is_active then
          return {
              { Text = " " .. tab.active_pane.title .. " " },
          }
      end

      for _, pane in ipairs(tab.panes) do
          if pane.has_unseen_output then
              return {
                  { Background = { Color = "orange" } },
                  { Text = " " .. tab.active_pane.title .. " " },
              }
          end
      end

      return tab.active_pane.title
  end)

  return config
''
