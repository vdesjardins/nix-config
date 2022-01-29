require"lspconfig".bashls.setup {
  cmd = { "bash-language-server", "start" },
  on_attach = require"components.config.lsp".common_on_attach,
  filetypes = { "sh", "zsh" },
}
