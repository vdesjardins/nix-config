local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").nixd.setup({
    on_attach = require("my-config.lsp").common_on_attach_no_formatting,
    capabilities = capabilities,
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.statix
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.code_actions.statix
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.alejandra
