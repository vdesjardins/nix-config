require"compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = { kind = "  " },
    buffer = { kind = "  " },
    calc = { kind = "  " },
    nvim_lsp = { kind = "  " },
    nvim_lua = { kind = "  " },
    spell = { kind = "  " },
    tags = false,
    -- snippets_nvim = {kind = "  "},
    ultisnips = { kind = "  " },
    -- treesitter = {kind = "  "},
    emoji = { kind = " ﲃ ", filetypes = { "markdown" } },
    -- for emoji press : (idk if that in compe tho)
    latex_symbols = true,
  },
}

-- mappings
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()",
                        { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<CR>", [[compe#confirm('<C-y>')]],
                        { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-e>", [[compe#close('<C-e>')]],
                        { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-f>", [[compe#scroll({ 'delta': +4 })]],
                        { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-d>", [[compe#scroll({ 'delta': -4 })]],
                        { noremap = true, expr = true, silent = true })

