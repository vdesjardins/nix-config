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
    wk.add({
        "s",
        function()
            require("flash").jump()
        end,
        desc = "Flash",
    }, {
        "S",
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
    })
end

wk.add({
    "r",
    function()
        require("flash").remote()
    end,
    desc = "Remote Flash",
    mode = "o",
})

wk.add({
    "R",
    function()
        require("flash").treesitter_search()
    end,
    desc = "Treesitter Search",
    mode = "o",
})
wk.add({
    "R",
    function()
        require("flash").treesitter_search()
    end,
    desc = "Treesitter Search",
    mode = "x",
})

wk.add({
    "<c-s>",
    function()
        require("flash").toggle()
    end,
    desc = "Toggle Flash Search",
    mode = "c",
})
