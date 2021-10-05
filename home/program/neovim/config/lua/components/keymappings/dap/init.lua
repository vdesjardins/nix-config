local wk = require("which-key")
wk.register({
  d = {
    name = "debugging",
    o = { "<cmd>lua require(\"dapui\").open()<cr>", "open" },
    c = { "<cmd>lua require(\"dapui\").close()<cr>", "close" },
    t = { "<cmd>lua require(\"dapui\").close()<cr>", "toggle" },
  },
}, { prefix = "<leader>" })
