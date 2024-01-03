local wezterm = require("wezterm")

local mouse = {}

local function make_mouse_binding(dir, streak, button, mods, action)
    return {
        event = { [dir] = { streak = streak, button = button } },
        mods = mods,
        action = action,
    }
end

function mouse.configure(config)
    config.mouse_bindings = {
        {
            event = { Down = { streak = 3, button = "Left" } },
            action = { SelectTextAtMouseCursor = "SemanticZone" },
            mods = "NONE",
        },
        make_mouse_binding(
            "Up",
            1,
            "Left",
            "NONE",
            wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
        ),
        make_mouse_binding(
            "Up",
            1,
            "Left",
            "SHIFT",
            wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
        ),
        make_mouse_binding(
            "Up",
            1,
            "Left",
            "ALT",
            wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")
        ),
        make_mouse_binding(
            "Up",
            1,
            "Left",
            "SHIFT|ALT",
            wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
        ),
        make_mouse_binding(
            "Up",
            2,
            "Left",
            "NONE",
            wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")
        ),
        make_mouse_binding(
            "Up",
            3,
            "Left",
            "NONE",
            wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")
        ),
    }

    config.pane_focus_follows_mouse = true

    return config
end

return mouse
