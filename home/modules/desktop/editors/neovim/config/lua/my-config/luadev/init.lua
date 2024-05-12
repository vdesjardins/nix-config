require("luadev")

local wk = require("which-key")

wk.register({
    n = {
        name = "neovim",
        l = {
            name = "luadev",
            l = { "<Plug>(Luadev-RunLine)", "run-line" },
            a = { "<Plug>(Luadev-Run)", "run" },
            e = { "<Plug>(Luadev-RunWord)", "run-word" },
        },
    },
}, { prefix = "<leader>" })
