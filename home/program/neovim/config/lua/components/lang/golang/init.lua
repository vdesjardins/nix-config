local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "gopls" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "gopls" end

return cfg
