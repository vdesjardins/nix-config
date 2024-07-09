require("lspconfig").yamlls.setup({
    settings = {
        yaml = {
            keyOrdering = false,
            schemaStore = {
                enable = false,
                url = "",
            },
            schemas = require("schemastore").yaml.schemas({
                ignore = {
                    "Deployer Recipe",
                },
            }),
        },
    },
})

require("yaml-companion").setup({})

local wk = require("which-key")
wk.register({
    b = {
        name = "buffer",
        y = { "<cmd>Telescope yaml_schema<cr>", "yaml-schema-chooser" },
    },
}, { prefix = "<leader>" })

local null_ls = require("null-ls")
_G.null_ls_sources[#_G.null_ls_sources + 1] = null_ls.builtins.diagnostics.yamllint
