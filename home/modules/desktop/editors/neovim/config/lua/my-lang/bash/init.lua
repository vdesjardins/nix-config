require("lspconfig").bashls.setup({
    cmd = { "bash-language-server", "start" },
    on_attach = require("my-config.lsp").common_on_attach,
    filetypes = { "sh", "zsh" },
})

local null_ls = require("null-ls")
null_ls.register(null_ls.builtins.formatting.shfmt)
null_ls.register(null_ls.builtins.formatting.shellharden)
