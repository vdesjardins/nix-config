local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "rnix-lsp", "--stdio" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "rnix" end

return cfg
