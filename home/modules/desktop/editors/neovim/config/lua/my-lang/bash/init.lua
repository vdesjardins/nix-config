local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").bashls.setup({
    cmd = { "bash-language-server", "start" },
    on_attach = require("my-config.lsp").common_on_attach,
    filetypes = { "sh", "zsh" },
    capabilities = capabilities,
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.shfmt
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.formatting.shellharden
