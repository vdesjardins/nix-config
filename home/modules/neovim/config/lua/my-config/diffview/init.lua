local wk = require("which-key")
wk.register({
    g = {
        name = "git",
        D = {
            name = "diffview",
            o = { vim.cmd.DiffviewOpen, "open" },
            c = { vim.cmd.DiffviewClose, "close" },
            f = { vim.cmd.DiffviewFocusFiles, "focus" },
            r = { vim.cmd.DiffviewRefresh, "refresh" },
        },
    },
}, { prefix = "<leader>" })
