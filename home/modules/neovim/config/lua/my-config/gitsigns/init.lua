require("gitsigns").setup({})

local wk = require("which-key")
wk.register({
    g = {
        name = "git",
        n = { "<cmd>Gitsigns next_hunk<cr>", "next-hunk" },
        p = { "<cmd>Gitsigns prev_hunk<cr>", "previous-hunk" },
    },
}, { prefix = "<leader>" })
