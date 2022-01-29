require"lspconfig".rust_analyzer.setup {
  cmd = { "rust-analyzer" },
  on_attach = require"components.config.lsp".common_on_attach,
}
