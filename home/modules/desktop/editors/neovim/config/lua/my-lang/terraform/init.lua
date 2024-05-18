local util = require("lspconfig.util")
require("lspconfig").terraformls.setup({
    cmd = { "terraform-ls", "serve" },
    on_attach = require("my-config.lsp").common_on_attach,
})

require("lspconfig").tflint.setup({
    root_dir = util.root_pattern(".git", ".tflint.hcl"),
})
