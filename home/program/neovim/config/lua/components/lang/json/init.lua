local cfg = {}

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function cfg.lsp_setup()
  return {
    cmd = { "json-languageserver", "--stdio" },
    capabilities = capabilities,
  }
end

function cfg.lsp_name() return "jsonls" end

return cfg
