vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0

-- show extra whitespaces
vim.cmd([[ highlight ExtraWhitespace ctermbg=167 guibg=#fb4934 ]])

vim.cmd([[autocmd FileType markdown EnableWhitespace]])

local whitespace_group = vim.api.nvim_create_augroup("whitespace", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    group = whitespace_group,
    command = "DisableWhitespace",
})
