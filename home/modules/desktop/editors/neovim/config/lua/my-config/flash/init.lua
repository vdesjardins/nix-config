require("flash").setup({
    modes = {
        search = {
            enabled = true,
        },
    },
})

-- keybindings
local wk = require("which-key")

for _, m in ipairs({ [1] = "n", [2] = "x", [3] = "o" }) do
    wk.register({
        s = {
            function()
                require("flash").jump()
            end,
            "Flash",
        },
        S = {
            function()
                require("flash").treesitter()
            end,
            "Flash Treesitter",
        },
    }, { mode = m })
end

wk.register({
    r = {
        function()
            require("flash").remote()
        end,
        "Remote Flash",
    },
}, { mode = "o" })

wk.register({
    R = {
        function()
            require("flash").treesitter_search()
        end,
        "Treesitter Search",
    },
}, { mode = "o" })
wk.register({
    R = {
        function()
            require("flash").treesitter_search()
        end,
        "Treesitter Search",
    },
}, { mode = "x" })

wk.register({
    ["<c-s>"] = {
        function()
            require("flash").toggle()
        end,
        "Toggle Flash Search",
    },
}, { mode = "c" })
