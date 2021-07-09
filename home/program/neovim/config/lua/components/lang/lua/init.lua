local cfg = {}

function cfg.lsp_setup()
  local setup = require("components.lang.lua.lua-lsp")
  setup.cmd = { "lua-language-server" }
  return setup
  -- return {
  --   cmd = { "lua-language-server" },
  --   on_attach = require"components.config.lsp".common_on_attach,
  --   settings = {
  --     Lua = {
  --       runtime = {
  --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
  --         version = "LuaJIT",
  --         -- Setup your lua path
  --         path = vim.split(package.path, ";"),
  --       },
  --       diagnostics = {
  --         -- Get the language server to recognize the `vim` global
  --         globals = { "vim" },
  --       },
  --       workspace = {
  --         -- Make the server aware of Neovim runtime files
  --         library = {
  --           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
  --           [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
  --         },
  --         maxPreload = 10000,
  --       },
  --     },
  --   },
  -- }
end

function cfg.lsp_name() return "sumneko_lua" end

return cfg
