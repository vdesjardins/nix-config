require("blame").setup()

local wk = require("which-key")

wk.register({
    g = {
        name = "git",
        b = { "<cmd>BlameToggle<cr>", "blame toggle" },
    },
}, { prefix = "<leader>" })
