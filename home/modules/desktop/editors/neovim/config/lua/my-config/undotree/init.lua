local wk = require("which-key")
wk.add({
    { "<leader>u", group = "undo" },
    { "<leader>ut", vim.cmd.UndotreeToggle, desc = "undotree-toggle" },
})
