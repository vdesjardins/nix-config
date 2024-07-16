require("gitsigns").setup({})

local wk = require("which-key")
wk.add({
    { "<leader>g", group = "git" },
    { "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", desc = "next-hunk" },
    { "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", desc = "previous-hunk" },
})
