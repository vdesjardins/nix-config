local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
    capabilities = capabilities,
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.cppcheck
