local wk = require("which-key")
wk.register({
    u = {
        name = "undo",
        t = { vim.cmd.UndotreeToggle, "undotree-toggle" },
    },
}, { prefix = "<leader>" })
