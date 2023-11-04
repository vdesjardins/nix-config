require("telescope").load_extension("harpoon")
require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
})

local wk = require("which-key")
local mappings = {
    m = {
        name = "harpoon (mark)",
        m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "add-file" },
        q = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "quick-menu" },
        n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "next" },
        p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "previous" },
    },
}

for i = 1, 9, 1 do
    mappings.m[tostring(i)] =
        { '<cmd>lua require("harpoon.ui").nav_file(' .. i .. ")<cr>", "goto " .. tostring(i) }
end

wk.register(mappings, { prefix = "<leader>" })
