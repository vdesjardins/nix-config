local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").gopls.setup({
	cmd = { "gopls" },
	on_attach = require("my-config.lsp").common_on_attach,
	capabilities = capabilities,
})
