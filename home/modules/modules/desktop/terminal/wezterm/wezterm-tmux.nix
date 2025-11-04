{
  font,
  font-italic,
  color-scheme,
}:
# lua
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

  function make_mouse_binding(dir, streak, button, mods, action)
    return {
      event = { [dir] = { streak = streak, button = button } },
      mods = mods,
      action = action,
    }
  end

  local config = {
      check_for_updates = false,
      color_scheme = "${color-scheme}",
      bold_brightens_ansi_colors = true,

      font = "${font}",
      font_italic = "${font-italic}",

      tab_bar_at_bottom = true,
      inactive_pane_hsb = { hue = 1.0, saturation = 0.5, brightness = 1.0 },
      exit_behavior = "Close",

      mouse_bindings = {
        {
            event = { Down = { streak = 3, button = "Left" } },
            action = { SelectTextAtMouseCursor = "SemanticZone" },
            mods = "NONE",
        },
        make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
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
