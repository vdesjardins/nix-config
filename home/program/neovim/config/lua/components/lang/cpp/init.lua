local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "clangd" },
    on_attach = require"components.config.lsp".common_on_attach,
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = false,
          signs = false,
          underline = false,
          update_in_insert = true,

        }),
    },
  }
end

function cfg.lsp_name() return "clangd" end

return cfg
