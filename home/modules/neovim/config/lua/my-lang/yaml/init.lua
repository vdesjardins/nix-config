local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").yamlls.setup({
	cmd = { "yaml-language-server", "--stdio" },
	on_attach = require("my-config.lsp").common_on_attach,
	capabilities = capabilities,
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.yamllint
