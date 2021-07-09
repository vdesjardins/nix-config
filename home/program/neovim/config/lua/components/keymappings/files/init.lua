local wk = require("which-key")
wk.register({
  f = {
    name = "find/files",
    d = { "<cmd>NvimTreeFindFile<cr>", "find-current-buffer-in-tree" },
    s = { "<cmd>write<cr>", "save-file" },
    S = { "<cmd>w !sudo tee % > /dev/null<cr>", "save-file-sudo" },
    t = { "<cmd>NvimTreeToggle<cr>", "toggle-tree" },
  },
}, { prefix = "<leader>" })
