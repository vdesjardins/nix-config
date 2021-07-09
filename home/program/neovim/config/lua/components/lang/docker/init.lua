local cfg = {}

function cfg.lsp_setup()
  return {
    cmd = { "docker-langserver", "--stdio" },
    on_attach = require"components.config.lsp".common_on_attach,
    root_dir = vim.loop.cwd,
  }
end

function cfg.lsp_name() return "dockerls" end

return cfg
