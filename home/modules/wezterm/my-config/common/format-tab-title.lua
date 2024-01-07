local wezterm = require("wezterm")

local M = {}

function M.configure(config)
    wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
        local title = " " .. tab.tab_index + 1 .. " " .. tab.active_pane.title .. " "
        if tab.is_active then
            return {
                { Background = { Color = "7AA2F7" } },
                { Foreground = { Color = "black" } },
                { Text = title },
            }
        end

        for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
                return {
                    { Background = { Color = "9ECE6A" } },
                    { Foreground = { Color = "black" } },
                    { Text = title },
                }
            end
        end

        return title
    end)
end

return M
