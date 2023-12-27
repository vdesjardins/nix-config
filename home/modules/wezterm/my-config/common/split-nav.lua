local wezterm = require("wezterm")

local split_nav = {}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
    Left = "h",
    Down = "j",
    Up = "k",
    Right = "l",
    -- reverse lookup
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function mapping(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == "resize" and "META" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
                }, pane)
            else
                if resize_or_move == "resize" then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

function split_nav.configure(config)
    -- move between split panes
    table.insert(config.keys, mapping("move", "h"))
    table.insert(config.keys, mapping("move", "j"))
    table.insert(config.keys, mapping("move", "k"))
    table.insert(config.keys, mapping("move", "l"))
    -- resize panes
    table.insert(config.keys, mapping("resize", "h"))
    table.insert(config.keys, mapping("resize", "j"))
    table.insert(config.keys, mapping("resize", "k"))
    table.insert(config.keys, mapping("resize", "l"))
end

return split_nav
