require("trouble").setup({})

local wk = require("which-key")
wk.register({
    l = {
        name = "lsp",
        t = {
            name = "trouble",
            x = { "<cmd>LspTroubleToggle<cr>", "trouble" },
            w = {
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                "trouble-workspace-diagnostics",
            },
            d = {
                "<cmd>TroubleToggle document_diagnostics<cr>",
                "trouble-document-diagnostics",
            },
            q = { "<cmd>TroubleToggle quickfix<cr>", "trouble-quickfix" },
            l = { "<cmd>TroubleToggle loclist<cr>", "trouble-loclist" },
            r = { "<cmd>TroubleToggle lsp_references<cr>", "trouble-references" },
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
