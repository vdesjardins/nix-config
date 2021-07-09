local wk = require("which-key")
wk.register({
  t = { name = "toggle", p = { "<cmd>set paste!<cr>", "paste-mode" } },
}, { prefix = "<leader>" })
