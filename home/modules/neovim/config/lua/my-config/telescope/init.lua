local _actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<c-t>"] = trouble.open_with_trouble,
                ["<C-h>"] = "which_key",
            },
            n = { ["<c-t>"] = trouble.open_with_trouble },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
})

telescope.load_extension("ui-select")

local wk = require("which-key")
wk.register({
    p = {
        name = "projects",
        f = { "<cmd>Telescope find_files<cr>", "find-file-in-project" },
        s = { "<cmd>Telescope live_grep<cr>", "search-in-project" },
        m = { "<cmd>Telescope marks<cr>", "bookmarks" },
        h = { "<cmd>Telescope help_tags<cr>", "help" },
    },
}, { prefix = "<leader>" })

vim.api.nvim_set_keymap("n", "gs", "<plug>(GrepperOperator)", { silent = true })
vim.api.nvim_set_keymap("x", "gs", "<plug>(GrepperOperator)", { silent = true })
