require("rust-tools").setup({
    server = {
        cmd = { "rust-analyzer" },
        on_attach = require("my-config.lsp").common_on_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
})
