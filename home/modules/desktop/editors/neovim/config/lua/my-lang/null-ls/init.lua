local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local null_ls = require("null-ls")

null_ls.setup({ capabilities = capabilities })

null_ls.register(null_ls.builtins.diagnostics.markdownlint)
