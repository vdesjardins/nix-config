local wk = require("which-key")
wk.add({
    { "<leader>g", group = "git" },
    { "<leader>gD", group = "diffview" },
    { "<leader>gDc", vim.cmd.DiffviewClose, desc = "close" },
    { "<leader>gDf", vim.cmd.DiffviewFocusFiles, desc = "focus" },
    { "<leader>gDo", vim.cmd.DiffviewOpen, desc = "open" },
    { "<leader>gDr", vim.cmd.DiffviewRefresh, desc = "refresh" },
})
