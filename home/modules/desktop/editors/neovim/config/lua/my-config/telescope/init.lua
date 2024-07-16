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
        file_browser = {
            cwd_to_path = true,
            hijack_netrw = true,
        },
    },
    pickers = {
        live_grep = {
            additional_args = function()
                return { "--hidden" }
            end,
        },
    },
})

telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local wk = require("which-key")
wk.add({
    {
        "<leader>bb",
        "<cmd>Telescope file_browser theme=dropdown path=%:p:help |select_buffer=true| hidden=true<CR>",
        desc = "file-browser",
    },
    { "<leader>p", group = "projects" },
    { "<leader>pM", "<cmd>Telescope marks theme=dropdown<cr>", desc = "bookmarks" },
    {
        "<leader>pb",
        "<cmd>Telescope file_browser theme=dropdown hidden=true<cr>",
        desc = "file-browser",
    },
    {
        "<leader>pf",
        "<cmd>Telescope find_files theme=dropdown hidden=true<cr>",
        desc = "find-file-in-project",
    },
    { "<leader>ph", "<cmd>Telescope help_tags theme=dropdown<cr>", desc = "help" },
    {
        "<leader>pr",
        "<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<cr>",
        desc = "frecency",
    },
    { "<leader>ps", "<cmd>Telescope live_grep theme=dropdown<cr>", desc = "search-in-project" },
    { "<leader>pt", "<cmd>Telescope builtin theme=dropdown<cr>", desc = "telescope" },
})

vim.api.nvim_set_keymap("n", "gs", "<plug>(GrepperOperator)", { silent = true })
vim.api.nvim_set_keymap("x", "gs", "<plug>(GrepperOperator)", { silent = true })
