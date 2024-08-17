local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local null_ls = require("null-ls")

null_ls.setup({ capabilities = capabilities })

local md = null_ls.builtins.diagnostics.markdownlint.with({
    runtime_condition = function(params)
        -- do not validate for gp plugin chats
        return not params.bufname:lower():match("gp/chats/.*.md$")
    end,
})
null_ls.register(md)
