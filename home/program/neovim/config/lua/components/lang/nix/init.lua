local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp
                                                                   .protocol
                                                                   .make_client_capabilities())
require"lspconfig".rnix.setup {
  cmd = { "rnix-lsp", "--stdio" },
  on_attach = require"components.config.lsp".common_on_attach,
  capabilities = capabilities,
}
