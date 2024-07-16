local wk = require("which-key")
wk.add({
    { "<leader>t", group = "toggle" },
    { "<leader>tp", "<cmd>set paste!<cr>", desc = "paste-mode" },
})
