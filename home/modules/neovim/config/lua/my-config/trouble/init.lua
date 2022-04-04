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
}, { prefix = "<leader>" })
