local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "yaml-language-server", "--stdio" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "yamlls" end

return cfg
