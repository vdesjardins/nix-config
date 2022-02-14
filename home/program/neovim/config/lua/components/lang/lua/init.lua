local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp
                                                                   .protocol
                                                                   .make_client_capabilities())
require"lspconfig".sumneko_lua.setup {
  lspconfig = { cmd = { "lua-language-server" } },
  capabilities = capabilities,
}
