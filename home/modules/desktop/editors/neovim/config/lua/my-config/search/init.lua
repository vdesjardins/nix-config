local wk = require("which-key")
wk.add({
    { "<leader>s", group = "search" },
    { "<leader>sc", "<cmd>Telescope commands theme=dropdown<cr>", desc = "commands" },
    { "<leader>sh", "<cmd>nohlsearch<cr>", desc = "clear-highlight" },
})
