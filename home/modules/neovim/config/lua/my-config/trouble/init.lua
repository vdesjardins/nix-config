require("trouble").setup({})

local wk = require("which-key")
wk.register({
    l = {
        name = "lsp",
        t = {
            name = "trouble",
            x = { "<cmd>LspTroubleToggle<cr>", "trouble" },
            w = {
                "<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>",
                "trouble-workspace-diagnostics",
            },
            d = {
                "<cmd>LspTroubleToggle lsp_document_diagnostics<cr>",
                "trouble-document-diagnostics",
            },
            q = { "<cmd>LspTroubleToggle quickfix<cr>", "trouble-quickfix" },
            l = { "<cmd>LspTroubleToggle loclist<cr>", "trouble-loclist" },
            r = { "<cmd>LspTroubleToggle lsp_references<cr>", "trouble-references" },
        },
    },
    r = {
        name = "trouble",
        n = { "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", "next" },
        p = {
            "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>",
            "previous",
        },
        f = { "<cmd>lua require('trouble').first({skip_groups = true, jump = true})<cr>", "first" },
        l = { "<cmd>lua require('trouble').last({skip_groups = true, jump = true})<cr>", "last" },
        t = { "<cmd>TroubleToggle<cr>", "toggle" },
    },
}, { prefix = "<leader>" })
