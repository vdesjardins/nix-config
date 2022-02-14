local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp
                                                                   .protocol
                                                                   .make_client_capabilities())
require"lspconfig".bashls.setup {
  cmd = { "bash-language-server", "start" },
  on_attach = require"components.config.lsp".common_on_attach,
  filetypes = { "sh", "zsh" },
  capabilities = capabilities,
}
