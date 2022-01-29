require"lspconfig".rnix.setup {
  cmd = { "rnix-lsp", "--stdio" },
  on_attach = require"components.config.lsp".common_on_attach,
}
