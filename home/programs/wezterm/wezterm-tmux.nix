{homeDirectory}: ''
  local wezterm = require("wezterm")

  wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

  -- tokyo night - night
  local function color_defs()
      return {
          foreground = "#c0caf5",
          background = "#1a1b26",
          cursor_bg = "#c0caf5",
          cursor_border = "#c0caf5",
          cursor_fg = "#1a1b26",
          selection_bg = "#33467C",
          selection_fg = "#c0caf5",

          ansi = {
              "#15161E",
              "#f7768e",
              "#9ece6a",
              "#e0af68",
              "#7aa2f7",
              "#bb9af7",
              "#7dcfff",
              "#a9b1d6",
          },
          brights = {
              "#414868",
              "#f7768e",
              "#9ece6a",
              "#e0af68",
              "#7aa2f7",
              "#bb9af7",
              "#7dcfff",
              "#c0caf5",
          },
      }
  end

  local config = {
      check_for_updates = false,
      font = wezterm.font("JetBrainsMono Nerd Font"),
      colors = color_defs(),
      tab_bar_at_bottom = true,
      inactive_pane_hsb = { hue = 1.0, saturation = 0.5, brightness = 1.0 },
      exit_behavior = "Close",

      mouse_bindings = {
          {
              event = { Down = { streak = 3, button = "Left" } },
              action = { SelectTextAtMouseCursor = "SemanticZone" },
              mods = "NONE",
          },
      },

      pane_focus_follows_mouse = true,
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
      local colors = { "#3c1361", "#52307c", "#663a82", "#7c5295", "#b491c8" }

      -- Foreground color for the text across the fade
      local text_fg = "#c0c0c0"

      -- The elements to be formatted
      local elements = {}
      -- How many cells have been formatted
      local num_cells = 0

      -- Translate a cell into elements
      local function push(text)
          local cell_no = num_cells + 1
          table.insert(elements, { Foreground = { Color = colors[cell_no] } })
          table.insert(elements, { Text = SOLID_LEFT_ARROW })
          table.insert(elements, { Foreground = { Color = text_fg } })
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
