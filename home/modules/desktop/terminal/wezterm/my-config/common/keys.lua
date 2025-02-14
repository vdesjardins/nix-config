local wezterm = require("wezterm")

local M = {}

function M.configure(config, globals)
  local act = wezterm.action

  config.leader =
  { key = globals.key_leader, mods = globals.mods_leader, timeout_milliseconds = 2000 }

  config.keys = {
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
    { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },

    -- workspaces
    {
      key = "S",
      mods = "LEADER|SHIFT",
      action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },

    -- utils
    { key = "`", mods = "LEADER", action = act({ SendString = "`" }) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
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
    { key = "r", mods = "LEADER",       action = "ReloadConfiguration" },
    { key = "R", mods = "LEADER|SHIFT", action = act.ShowLauncher },
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
    -- pane selection mode
    { key = "0",     mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
    -- rotate panes
    { key = "Space", mods = "LEADER", action = act.RotatePanes("Clockwise") },

    -- launch menu
    {
      key = "m",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
    },

    -- key maps
    {
      key = "?",
      mods = "LEADER|SHIFT",
      action = act({
        SplitVertical = {
          domain = "CurrentPaneDomain",
          args = { "bash", "-c", "${pkgs.wezterm}/bin/wezterm show-keys | less -I" },
        },
      }),
    },

    -- command palette
    { key = "C", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },

    -- selection
    -- { key = "S", mods = "LEADER|SHIFT", action = "QuickSelect" },
  }

  config.key_tables = {
    copy_mode = {
      { key = "c",      mods = "CTRL", action = act({ CopyMode = "Close" }) },
      { key = "g",      mods = "CTRL", action = act({ CopyMode = "Close" }) },
      { key = "q",      mods = "NONE", action = act({ CopyMode = "Close" }) },
      { key = "Escape", mods = "NONE", action = act({ CopyMode = "Close" }) },

      { key = "h",      mods = "NONE", action = act({ CopyMode = "MoveLeft" }) },
      { key = "j",      mods = "NONE", action = act({ CopyMode = "MoveDown" }) },
      { key = "k",      mods = "NONE", action = act({ CopyMode = "MoveUp" }) },
      { key = "l",      mods = "NONE", action = act({ CopyMode = "MoveRight" }) },

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
        key = "V",
        mods = "SHIFT",
        action = act.CopyMode({ SetSelectionMode = "Line" }),
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

      { key = "PageUp",  mods = "NONE", action = act({ CopyMode = "PageUp" }) },
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
        action = wezterm.action_callback(function(window, pane)
          window:perform_acttion(act.Search, 'CurrentSelectionOrEmptyString', pane)
          window.perform_action(
            act.Multiple { act.CopyMode 'ClearPattern', act.CopyMode 'ClearSelectionMode', act.CopyMode 'MoveToScrollBackBottom' },
            pane)
        end),
      },
      -- navigate any search mode results
      { key = "N", mods = "NONE",  action = act({ CopyMode = "NextMatch" }) },
      { key = "n", mods = "SHIFT", action = act({ CopyMode = "PriorMatch" }) },
    },
    search_mode = {
      { key = "Escape", mods = "NONE", action = act({ CopyMode = "Close" }) },
      -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
      -- to navigate search results without conflicting with typing into the search area.
      { key = "Enter",  mods = "NONE", action = "ActivateCopyMode" },
    },
  }

  config.launch_menu = {
    {
      args = { "htop" },
    },
    {
      args = { "btop" },
    },
  }
end

return M
