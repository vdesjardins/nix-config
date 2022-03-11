local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").dockerls.setup({
	cmd = { "docker-langserver", "--stdio" },
	on_attach = require("components.config.lsp").common_on_attach,
	root_dir = vim.loop.cwd,
	capabilities = capabilities,
})
