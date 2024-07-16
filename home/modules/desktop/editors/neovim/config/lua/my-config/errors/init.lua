local wk = require("which-key")
wk.add({
    { "<leader>e", group = "errors" },
    { "<leader>ec", "<cmd>cclose<cr>", desc = "close-quickfix-window" },
    { "<leader>en", "<cmd>cnext<cr>", desc = "next-error" },
    { "<leader>eo", "<cmd>copen<cr>", desc = "open-quickfix-window" },
    { "<leader>ep", "<cmd>cprevious<cr>", desc = "previous-error" },
})
