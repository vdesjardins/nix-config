local wk = require("which-key")
wk.register({
  s = { name = "search", c = { "<cmd>nohlsearch<cr>", "clear-highlight" } },
}, { prefix = "<leader>" })
