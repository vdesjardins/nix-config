local wk = require("which-key")
wk.register({
    s = {
        name = "search",
        h = { "<cmd>nohlsearch<cr>", "clear-highlight" },
        c = { "<cmd>Telescope commands<cr>", "commands" },
    },
}, { prefix = "<leader>" })
