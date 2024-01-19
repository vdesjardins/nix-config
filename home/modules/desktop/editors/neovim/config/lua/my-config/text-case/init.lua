require("textcase").setup({})
require("telescope").load_extension("textcase")
vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
vim.api.nvim_set_keymap(
    "n",
    "gaa",
    "<cmd>TextCaseOpenTelescopeQuickChange<CR>",
    { desc = "Telescope Quick Change" }
)
vim.api.nvim_set_keymap(
    "n",
    "gai",
    "<cmd>TextCaseOpenTelescopeLSPChange<CR>",
    { desc = "Telescope LSP Change" }
)
