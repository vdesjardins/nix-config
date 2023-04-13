local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig").yamlls.setup({
    cmd = { "yaml-language-server", "--stdio" },
    on_attach = require("my-config.lsp").common_on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
                Kubernetes = "*.yaml",
            },
            schemaDownload = {
                enable = true,
            },
            validate = true,
        },
    },
})

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.yamllint
