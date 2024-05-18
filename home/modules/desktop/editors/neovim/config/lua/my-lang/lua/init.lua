require("neodev").setup({
    override = function(root_dir, library)
        if require("neodev.util").has_file(root_dir, "modules/neovim") then
            library.enabled = true
            library.runtime = true
            library.types = true
            library.plugins = true
        end
    end,
    debug = true,
})

require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            hint = {
                enable = true,
                setType = true,
            },
            codeLens = {
                enable = true,
            },
            completion = {
                callSnippet = "Replace",
                postfix = ".",
                showWord = "Disable",
                workspaceWord = false,
            },
            formatter = { enable = false },
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.stylua
