local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp
                                                                   .protocol
                                                                   .make_client_capabilities())
require"lspconfig".clangd.setup {
  cmd = { "clangd" },
  on_attach = require"components.config.lsp".common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                         .on_publish_diagnostics,
                                                       {
      virtual_text = false,
      signs = false,
      underline = false,
      update_in_insert = true,

    }),
  },
  capabilities = capabilities,
}
