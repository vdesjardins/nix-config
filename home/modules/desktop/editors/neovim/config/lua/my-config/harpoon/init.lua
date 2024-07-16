local harpoon = require("harpoon")
harpoon:setup()

local wk = require("which-key")
local mappings = {
    { "<leader>m", group = "harpoon" },
    {
        "<leader>mm",
        function()
            harpoon:list():append()
        end,
        desc = "add-file",
    },
    {
        "<leader>mq",
        function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "quick-menu",
    },
    {
        "<leader>mn",
        function()
            harpoon:list():next()
        end,
        desc = "next",
    },
    {
        "<leader>mp",
        function()
            harpoon:list():prev()
        end,
        desc = "previous",
    },
}

for i = 1, 9, 1 do
    table.insert(mappings, {
        "<leader>m" .. tostring(i),
        function()
            harpoon:list():select(i)
        end,
        desc = "goto " .. tostring(i),
    })
end

wk.add(mappings)
