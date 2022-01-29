require"lspconfig".terraformls.setup {
  cmd = { "terraform-ls", "serve" },
  on_attach = require"components.config.lsp".common_on_attach,
}
