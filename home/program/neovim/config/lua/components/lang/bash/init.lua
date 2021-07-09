local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "bash-language-server", "start" },
    on_attach = require"components.config.lsp".common_on_attach,
    filetypes = { "sh", "zsh" },
  }
end

function cfg.lsp_name() return "bashls" end

return cfg
