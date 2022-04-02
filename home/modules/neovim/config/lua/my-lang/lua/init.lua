require("lspconfig").sumneko_lua.setup(require("my-lang.lua.lua-lsp"))

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.stylua
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.selene
