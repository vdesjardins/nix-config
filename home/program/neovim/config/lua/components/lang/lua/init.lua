local cfg = {}

function cfg.lsp_setup()
  return require("lua-dev").setup({
    lspconfig = { cmd = { "lua-language-server" } },
  })
end

function cfg.lsp_name() return "sumneko_lua" end

return cfg
