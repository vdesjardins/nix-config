local wezterm = require("wezterm")

local M = {}

function M.configure(config)
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
end

return M
