local _actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<c-h>"] = "which_key",
                ["<c-t>"] = trouble.open_with_trouble,
                ["<c-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
                ["<c-t>"] = trouble.open_with_trouble,
                ["<c-d>"] = require("telescope.actions").delete_buffer,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
        frecency = {
            show_scores = true,
        },
    },
})

telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local wk = require("which-key")
wk.register({
    p = {
        name = "projects",
        f = { "<cmd>Telescope find_files theme=dropdown<cr>", "find-file-in-project" },
        s = { "<cmd>Telescope live_grep theme=dropdown<cr>", "search-in-project" },
        m = { "<cmd>Telescope marks theme=dropdown<cr>", "bookmarks" },
        h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "help" },
        b = { "<cmd>Telescope file_browser theme=dropdown<cr>", "file-browser" },
        t = { "<cmd>Telescope theme=dropdown<cr>", "telescope" },
        r = {
            "<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<cr>",
            "frecency",
        },
    },
    b = {
        b = {
            "<cmd>Telescope file_browser theme=dropdown path=%:p:h select_buffer=true<CR>",
            "file-browser",
        },
    },
}, { prefix = "<leader>" })

vim.api.nvim_set_keymap("n", "gs", "<plug>(GrepperOperator)", { silent = true })
vim.api.nvim_set_keymap("x", "gs", "<plug>(GrepperOperator)", { silent = true })
