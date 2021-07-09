local wk = require("which-key")
wk.register({
  g = {
    name = "git",
    b = { "<cmd>Git blame<cr>", "fugitive-blame" },
    c = { "<cmd>Git commit<cr>", "fugitive-commit" },
    d = { "<cmd>Gdiffsplit<cr>", "fugitive-diff" },
    e = { "<cmd>Gedit<cr>", "fugitive-edit" },
    l = { "<cmd>Gclog<cr>", "fugitive-log" },
    r = { "<cmd>Gread<cr>", "fugitive-read" },
    s = { "<cmd>Git<cr>", "fugitive-status" },
    w = { "<cmd>Gwrite<cr>", "fugitive-write" },
    p = { "<cmd>Git push<cr>", "fugitive-push" },
    P = { "<cmd>Git pull<cr>", "fugitive-pull" },
  },
}, { prefix = "<leader>" })
