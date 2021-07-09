local wk = require("which-key")
wk.register({
  m = {
    name = "plugins",
    s = { "<cmd>PackerSync<cr>", "packer-sync" },
    c = { "<cmd>PackerCompile<cr>", "packer-compile" },
    i = { "<cmd>PackerInstall<cr>", "packer-install" },
    u = { "<cmd>PackerUpdate<cr>", "packer-update" },
  },
}, { prefix = "<leader>" })
