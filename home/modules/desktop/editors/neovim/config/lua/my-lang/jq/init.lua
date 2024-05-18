require("lspconfig").jqls.setup({
    on_attach = require("my-config.lsp").common_on_attach,
})

vim.cmd("au BufRead,BufNewFile *.jq setfiletype jq")
