require("lspconfig").dockerls.setup({
    cmd = { "docker-langserver", "--stdio" },
    on_attach = require("my-config.lsp").common_on_attach,
    root_dir = vim.loop.cwd,
})

local null_ls = require("null-ls")
null_ls.register(null_ls.builtins.diagnostics.hadolint)
