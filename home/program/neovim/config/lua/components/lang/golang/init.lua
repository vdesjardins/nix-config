require"lspconfig".gopls.setup {
  cmd = { "gopls" },
  on_attach = require"components.config.lsp".common_on_attach,
}
