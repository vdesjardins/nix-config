require"lspconfig".yamlls.setup {
  cmd = { "yaml-language-server", "--stdio" },
  on_attach = require"components.config.lsp".common_on_attach,
}
