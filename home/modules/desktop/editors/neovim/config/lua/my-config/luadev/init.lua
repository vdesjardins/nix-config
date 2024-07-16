require("luadev")

local wk = require("which-key")

wk.add({
    { "<leader>n", group = "neovim" },
    { "<leader>nl", group = "luadev" },
    { "<leader>nla", "<Plug>(Luadev-Run)", desc = "run" },
    { "<leader>nle", "<Plug>(Luadev-RunWord)", desc = "run-word" },
    { "<leader>nll", "<Plug>(Luadev-RunLine)", desc = "run-line" },
})
