local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
require("rust-tools").setup({
    server = {
        cmd = { "rust-analyzer" },
        on_attach = require("my-config.lsp").common_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
})
