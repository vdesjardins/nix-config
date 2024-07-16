local wk = require("which-key")
wk.add({
    { "<leader>x", group = "text" },
    {
        "<leader>xd",
        "<cmd>StripWhiteSpace<CR>",
        desc = "delete-trailing-whitespaces",
    },
    { "<leader>xf", "<cmd>lua vim.lsp.buf.formatting_seq_sync(nil, 200)<cr>", desc = "format" },
})

wk.add({
    {
        { "<leader>x", group = "text", mode = "v" },
        {
            "<leader>xd",
            "<cmd>StripWhiteSpace<CR>",
            desc = "delete-trailing-whitespaces",
            mode = "v",
        },
        {
            "<leader>xf",
            "<cmd>lua vim.lsp.buf.range_formatting()<cr>",
            desc = "format",
            mode = "v",
        },
    },
})
