local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "json-languageserver", "--stdio" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "jsonls" end

return cfg
