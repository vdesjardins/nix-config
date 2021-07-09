local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "rust-analyzer" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "rust_analyzer" end

return cfg
