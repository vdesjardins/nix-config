local wezterm = require("wezterm")

local hyperlinks = {}

local function define_hyperlinks()
    local hyperlink_rules = wezterm.default_hyperlink_rules()

    -- make username/project paths clickable. this implies paths like the following are for github.
    table.insert(hyperlink_rules, {
        regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
        format = "https://www.github.com/$1/$3",
    })

    return hyperlink_rules
end

function hyperlinks.configure(config)
    config.hyperlink_rules = define_hyperlinks()
end

return hyperlinks
