require("lspconfig").nixd.setup({
    on_attach = require("my-config.lsp").common_on_attach_no_formatting,
})

local null_ls = require("null-ls")
null_ls.register(null_ls.builtins.diagnostics.statix)
null_ls.register(null_ls.builtins.code_actions.statix)
null_ls.register(null_ls.builtins.formatting.alejandra)
