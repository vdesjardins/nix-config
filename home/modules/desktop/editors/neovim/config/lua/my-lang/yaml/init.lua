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
wk.add({
    { "<leader>b", group = "buffer" },
    { "<leader>by", "<cmd>Telescope yaml_schema<cr>", desc = "yaml-schema-chooser" },
})

local null_ls = require("null-ls")
null_ls.register(null_ls.builtins.diagnostics.yamllint)
