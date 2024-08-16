require("lspconfig").clangd.setup({
    cmd = { "clangd" },
    on_attach = require("my-config.lsp").common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            {
                virtual_text = false,
                signs = false,
                underline = false,
                update_in_insert = true,
            }
        ),
    },
})

local null_ls = require("null-ls")
null_ls.register(null_ls.builtins.diagnostics.cppcheck)
