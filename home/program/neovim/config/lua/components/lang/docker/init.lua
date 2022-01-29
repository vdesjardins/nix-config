require"lspconfig".dockerls.setup {
  cmd = { "docker-langserver", "--stdio" },
  on_attach = require"components.config.lsp".common_on_attach,
  root_dir = vim.loop.cwd,
}
