{
  homeDirectory,
  font,
}:
/*
lua
*/
''
  wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

  local function hyperlinks()
    hyperlink_rules = wezterm.default_hyperlink_rules()

    -- make username/project paths clickable. this implies paths like the following are for github.
    table.insert(hyperlink_rules, {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = 'https://www.github.com/$1/$3',
    })

    return hyperlink_rules
  end

  local config = {
      check_for_updates = false,
      font = wezterm.font({
        family = "${font}",
        weight = "Medium",
        harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig' },
      }),
      color_scheme = 'tokyonight_storm',
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

      hide_tab_bar_if_only_one_tab = true,

      hyperlink_rules = hyperlinks(),
  }


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
