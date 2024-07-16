require("trouble").setup({})

local wk = require("which-key")
wk.add({
    { "<leader>l", group = "lsp" },
    { "<leader>lt", group = "trouble" },
    {
        "<leader>ltd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "trouble-document-diagnostics",
    },
    { "<leader>ltl", "<cmd>TroubleToggle loclist<cr>", desc = "trouble-loclist" },
    { "<leader>ltq", "<cmd>TroubleToggle quickfix<cr>", desc = "trouble-quickfix" },
    { "<leader>ltr", "<cmd>TroubleToggle lsp_references<cr>", desc = "trouble-references" },
    {
        "<leader>ltw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "trouble-workspace-diagnostics",
    },
    { "<leader>ltx", "<cmd>LspTroubleToggle<cr>", desc = "trouble" },
    { "<leader>r", group = "trouble" },
    {
        "<leader>rf",
        "<cmd>lua require('trouble').first({skip_groups = true, jump = true})<cr>",
        desc = "first",
    },
    {
        "<leader>rl",
        "<cmd>lua require('trouble').last({skip_groups = true, jump = true})<cr>",
        desc = "last",
    },
    {
        "<leader>rn",
        "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>",
        desc = "next",
    },
    {
        "<leader>rp",
        "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>",
        desc = "previous",
    },
    { "<leader>rt", "<cmd>TroubleToggle<cr>", desc = "toggle" },
})
