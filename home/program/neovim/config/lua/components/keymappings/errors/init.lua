local wk = require("which-key")
wk.register({
  e = {
    name = "errors",
    n = { "<cmd>cnext<cr>", "next-error" },
    p = { "<cmd>cprevious<cr>", "previous-error" },
    c = { "<cmd>cclose<cr>", "close-quickfix-window" },
  },
}, { prefix = "<leader>" })
