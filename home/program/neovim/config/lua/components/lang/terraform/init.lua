local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "terraform-ls", "serve" },
    on_attach = require"components.config.lsp".common_on_attach,
  }
end

function cfg.lsp_name() return "terraformls" end

return cfg
