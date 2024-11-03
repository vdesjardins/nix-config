require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "llama3",
        },
        inline = {
            adapter = "llama3",
        },
    },
    adapters = {
        llama3 = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "llama3",
                schema = {
                    model = {
                        default = "llama3:latest",
                    },
                },
            })
        end,
    },
})

local wk = require("which-key")
wk.add({
    {
        "C-a",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion Actions",
        mode = "n",
    },
    {
        "C-a",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion Actions",
        mode = "v",
    },
    {
        "<Leader>a",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanionChat Toggle",
        mode = "n",
    },
    {
        "<Leader>a",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanionChat Toggle",
        mode = "v",
    },
    {
        "ga",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "CodeCompanionChat Add",
        mode = "v",
    },
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
