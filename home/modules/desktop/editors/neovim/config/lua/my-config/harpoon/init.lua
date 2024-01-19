local harpoon = require("harpoon")
harpoon:setup()

local wk = require("which-key")
local mappings = {
    m = {
        name = "harpoon",
        m = {
            function()
                harpoon:list():append()
            end,
            "add-file",
        },
        q = {
            function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            "quick-menu",
        },
        n = {
            function()
                harpoon:list():next()
            end,
            "next",
        },
        p = {
            function()
                harpoon:list():prev()
            end,
            "previous",
        },
    },
}

for i = 1, 9, 1 do
    mappings.m[tostring(i)] = {
        function()
            harpoon:list():select(i)
        end,
        "goto " .. tostring(i),
    }
end

wk.register(mappings, { prefix = "<leader>" })
