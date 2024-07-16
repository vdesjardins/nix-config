local wk = require("which-key")
wk.add({
    { "<leader>f", group = "find/files" },
    { "<leader>fS", "<cmd>w !sudo tee % > /dev/null<cr>", desc = "save-file-sudo" },
    { "<leader>fs", "<cmd>write<cr>", desc = "save-file" },
})
