local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").jqls.setup({
    on_attach = require("my-config.lsp").common_on_attach,
    capabilities = capabilities,
})

vim.cmd("au BufRead,BufNewFile *.jq setfiletype jq")
