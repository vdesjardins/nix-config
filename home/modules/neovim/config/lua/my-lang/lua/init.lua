local luadev = require("lua-dev").setup({
    lspconfig = {
        settings = {
            Lua = {
                formatter = { enable = false },
            },
        },
    },
})

require("lspconfig").sumneko_lua.setup(luadev)

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.stylua
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.selene
