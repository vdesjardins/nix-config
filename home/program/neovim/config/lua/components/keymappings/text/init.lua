local wk = require("which-key")
wk.register({
  x = {
    name = "text",
    d = { "<cmd>StripWhiteSpace<CR>", "delete-trailing-whitespaces" },
    f = { "<cmd>lua vim.lsp.buf.formatting_sync(nil, 200)<cr>", "format" },
  },
}, { prefix = "<leader>" })

wk.register({
  x = {
    name = "text",
    f = { "<cmd>lua vim.lsp.buf.range_formatting()<cr>", "format" },
  },
}, { mode = "v", prefix = "<leader>" })
