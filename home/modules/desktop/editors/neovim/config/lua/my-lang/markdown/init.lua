local markdownGroup = vim.api.nvim_create_augroup("markdown", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.md" },
    callback = function()
        vim.opt_local.conceallevel = 2
    end,
    group = markdownGroup,
})
