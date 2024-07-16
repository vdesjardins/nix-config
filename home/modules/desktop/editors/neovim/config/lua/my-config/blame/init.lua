require("blame").setup()

local wk = require("which-key")

wk.add({
    { "<leader>g", group = "git" },
    { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "blame toggle" },
})
