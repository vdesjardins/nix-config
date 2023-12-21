{
  homeDirectory,
  font,
}:
/*
lua
*/
''
  wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

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
