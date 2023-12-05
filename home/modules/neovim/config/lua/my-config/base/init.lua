vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

-- better window movement
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })
vim.api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { silent = true })
vim.api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { silent = true })
vim.api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { silent = true })
vim.api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { silent = true })
vim.api.nvim_set_keymap("t", "<esc><esc>", "<C-\\><C-n>", { silent = true })

-- resize with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", "resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", "resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", "vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", "vertical resize +2<CR>", { silent = true })

-- Disable arrow keys
vim.api.nvim_set_keymap("n", "<up>", "<nop>", {})
vim.api.nvim_set_keymap("n", "<down>", "<nop>", {})
vim.api.nvim_set_keymap("n", "<left>", "<nop>", {})
vim.api.nvim_set_keymap("n", "<right>", "<nop>", {})
vim.api.nvim_set_keymap("i", "<up>", "<nop>", {})
vim.api.nvim_set_keymap("i", "<down>", "<nop>", {})
vim.api.nvim_set_keymap("i", "<left>", "<nop>", {})
vim.api.nvim_set_keymap("i", "<right>", "<nop>", {})
