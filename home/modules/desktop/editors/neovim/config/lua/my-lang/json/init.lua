-- Enable (broadcasting) snippet capability for completion
local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig")["jsonls"].setup({ capabilities = capabilities })
