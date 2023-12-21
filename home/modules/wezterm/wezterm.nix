{
  key_leader ? "`",
  mods_leader ? "",
  homeDirectory,
  font,
}:
/*
lua
*/
''
  local act = wezterm.action

  -- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
  local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == 'true'
  end

  local direction_keys = {
    Left = 'h',
    Down = 'j',
    Up = 'k',
    Right = 'l',
    -- reverse lookup
    h = 'Left',
    j = 'Down',
    k = 'Up',
    l = 'Right',
  }

  local function split_nav(resize_or_move, key)
    return {
      key = key,
      mods = resize_or_move == 'resize' and 'META' or 'CTRL',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          -- pass the keys through to vim/nvim
          win:perform_action({
            SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
          }, pane)
        else
          if resize_or_move == 'resize' then
            win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
          else
            win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
          end
        end
      end),
    }
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
    inactive_pane_hsb = { hue = 1.0, saturation = 0.9, brightness = 1.0 },
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
      -- move between split panes
      split_nav('move', 'h'),
      split_nav('move', 'j'),
      split_nav('move', 'k'),
      split_nav('move', 'l'),
      -- resize panes
      split_nav('resize', 'h'),
      split_nav('resize', 'j'),
      split_nav('resize', 'k'),
      split_nav('resize', 'l'),
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    {
        key = "s",
        mods = "LEADER",
        action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "v",
        mods = "LEADER",
        action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
      -- tabs
      {
          key = "c",
          mods = "LEADER",
          action = act({ SpawnTab = "CurrentPaneDomain" }),
      },
      { key = "b", mods = "LEADER", action = "ActivateLastTab" },
      { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
      { key = "p", mods = "LEADER", action = act({ ActivateTabRelative = -1 }) },
      { key = "n", mods = "LEADER", action = act({ ActivateTabRelative = 1 }) },
      { key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
      { key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
      { key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
      { key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
      { key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
      { key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
      { key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
      { key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
      { key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
      {
          key = "&",
          mods = "LEADER|SHIFT",
          action = act({ CloseCurrentTab = { confirm = true } }),
      },
      { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS'} },

      -- workspaces
      { key = 'S', mods = 'LEADER|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES'} },

      -- utils
      { key = "`", mods = "LEADER", action = act({ SendString = "`" }) },
      {
          key = "~",
          mods = "LEADER|SHIFT",
          action = act({
              SplitVertical = {
                  domain = "CurrentPaneDomain",
                  args = { "htop" },
              },
          }),
      },
      { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
      { key = 'R', mods = 'LEADER|SHIFT', action = wezterm.action.ShowLauncher },
      {
          key = "Backspace",
          mods = "LEADER",
          action = act({ ClearScrollback = "ScrollbackAndViewport" }),
      },
      { key = "[", mods = "LEADER", action = "ActivateCopyMode" },
      { key = "E", mods = "LEADER", action = act({ EmitEvent = "open-in-vim" }) },
      {
          key = "]",
          mods = "LEADER",
          action = act({ PasteFrom = "PrimarySelection" }),
      },

      -- launch menu
      { key = 'm', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS'} },

      -- command palette
      { key = 'C', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },

      -- selection
      -- { key = "S", mods = "LEADER|SHIFT", action = "QuickSelect" },
  },

  key_tables = {
      copy_mode = {
          { key = "c", mods = "CTRL", action = act({ CopyMode = "Close" }) },
          { key = "g", mods = "CTRL", action = act({ CopyMode = "Close" }) },
          { key = "q", mods = "NONE", action = act({ CopyMode = "Close" }) },
          { key = "Escape", mods = "NONE", action = act({ CopyMode = "Close" }) },

          { key = "h", mods = "NONE", action = act({ CopyMode = "MoveLeft" }) },
          { key = "j", mods = "NONE", action = act({ CopyMode = "MoveDown" }) },
          { key = "k", mods = "NONE", action = act({ CopyMode = "MoveUp" }) },
          { key = "l", mods = "NONE", action = act({ CopyMode = "MoveRight" }) },

          {
              key = "LeftArrow",
              mods = "NONE",
              action = act({ CopyMode = "MoveLeft" }),
          },
          {
              key = "DownArrow",
              mods = "NONE",
              action = act({ CopyMode = "MoveDown" }),
          },
          { key = "UpArrow", mods = "NONE", action = act({ CopyMode = "MoveUp" }) },
          {
              key = "RightArrow",
              mods = "NONE",
              action = act({ CopyMode = "MoveRight" }),
          },

          {
              key = "RightArrow",
              mods = "ALT",
              action = act({
                  CopyMode = "MoveForwardWord",
              }),
          },
          {
              key = "f",
              mods = "ALT",
              action = act({ CopyMode = "MoveForwardWord" }),
          },
          {
              key = "Tab",
              mods = "NONE",
              action = act({ CopyMode = "MoveForwardWord" }),
          },
          {
              key = "w",
              mods = "NONE",
              action = act({ CopyMode = "MoveForwardWord" }),
          },

          {
              key = "LeftArrow",
              mods = "ALT",
              action = act({
                  CopyMode = "MoveBackwardWord",
              }),
          },
          {
              key = "b",
              mods = "ALT",
              action = act({ CopyMode = "MoveBackwardWord" }),
          },
          {
              key = "Tab",
              mods = "SHIFT",
              action = act({ CopyMode = "MoveBackwardWord" }),
          },
          {
              key = "b",
              mods = "NONE",
              action = act({ CopyMode = "MoveBackwardWord" }),
          },

          {
              key = "0",
              mods = "NONE",
              action = act({ CopyMode = "MoveToStartOfLine" }),
          },
          {
              key = "Enter",
              mods = "NONE",
              action = act({
                  CopyMode = "MoveToStartOfNextLine",
              }),
          },
          {
              key = "$",
              mods = "NONE",
              action = act({
                  CopyMode = "MoveToEndOfLineContent",
              }),
          },
          {
              key = "$",
              mods = "SHIFT",
              action = act({
                  CopyMode = "MoveToEndOfLineContent",
              }),
          },

          {
              key = "m",
              mods = "ALT",
              action = act({
                  CopyMode = "MoveToStartOfLineContent",
              }),
          },
          {
              key = "^",
              mods = "NONE",
              action = act({
                  CopyMode = "MoveToStartOfLineContent",
              }),
          },
          {
              key = "^",
              mods = "SHIFT",
              action = act({
                  CopyMode = "MoveToStartOfLineContent",
              }),
          },
          {
              key = "Space",
              mods = "NONE",
              action = act({
                  CopyMode = { SetSelectionMode = "Cell" },
              }),
          },
          {
              key = "v",
              mods = "NONE",
              action = act({
                  CopyMode = { SetSelectionMode = "Cell" },
              }),
          },
          {
              key = "v",
              mods = "CTRL",
              action = act({
                  CopyMode = { SetSelectionMode = "Block" },
              }),
          },
          {
            key = 'V',
            mods = 'SHIFT',
            action = act.CopyMode { SetSelectionMode = 'Line' },
          },
          {
              key = "y",
              mods = "NONE",
              action = act({
                  Multiple = {
                      act({ CopyTo = "ClipboardAndPrimarySelection" }),
                      act({ CopyMode = "Close" }),
                  },
              }),
          },
          {
              key = "G",
              mods = "NONE",
              action = act({
                  CopyMode = "MoveToScrollbackBottom",
              }),
          },
          {
              key = "G",
              mods = "SHIFT",
              action = act({
                  CopyMode = "MoveToScrollbackBottom",
              }),
          },
          {
              key = "g",
              mods = "NONE",
              action = act({ CopyMode = "MoveToScrollbackTop" }),
          },

          {
              key = "H",
              mods = "NONE",
              action = act({ CopyMode = "MoveToViewportTop" }),
          },
          {
              key = "H",
              mods = "SHIFT",
              action = act({ CopyMode = "MoveToViewportTop" }),
          },
          {
              key = "M",
              mods = "NONE",
              action = act({ CopyMode = "MoveToViewportMiddle" }),
          },
          {
              key = "M",
              mods = "SHIFT",
              action = act({
                  CopyMode = "MoveToViewportMiddle",
              }),
          },
          {
              key = "L",
              mods = "NONE",
              action = act({ CopyMode = "MoveToViewportBottom" }),
          },
          {
              key = "L",
              mods = "SHIFT",
              action = act({
                  CopyMode = "MoveToViewportBottom",
              }),
          },

          { key = "PageUp", mods = "NONE", action = act({ CopyMode = "PageUp" }) },
          {
              key = "PageDown",
              mods = "NONE",
              action = act({ CopyMode = "PageDown" }),
          },

          { key = "b", mods = "CTRL", action = act({ CopyMode = "PageUp" }) },
          { key = "f", mods = "CTRL", action = act({ CopyMode = "PageDown" }) },
          -- Enter search mode to edit the pattern.
          -- When the search pattern is an empty string the existing pattern is preserved
          {
              key = "?",
              mods = "NONE",
              action = act({
                  Search = {
                      CaseSensitiveString = "",
                  },
              }),
          },
          -- navigate any search mode results
          { key = "N", mods = "NONE", action = act({ CopyMode = "NextMatch" }) },
          { key = "n", mods = "SHIFT", action = act({ CopyMode = "PriorMatch" }) },
      },
      search_mode = {
          { key = "Escape", mods = "NONE", action = act({ CopyMode = "Close" }) },
          -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
          -- to navigate search results without conflicting with typing into the search area.
          { key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
      },
    },

    launch_menu = {
      {
        args = { 'htop' },
      },
      {
        args = { 'btop' },
      },
    },
  }

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
            { Background = { Color = "yellow" } },
            { Text = " " .. tab.active_pane.title .. " " },
        }
      end
    end

    return tab.active_pane.title
  end)

  return config
''
