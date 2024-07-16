local wk = require("which-key")
wk.add({
    { "<leader>b", group = "buffer" },
    { "<leader>bD", "<cmd>bufdo bdelete<cr>", desc = "delete-buffer (all)" },
    { "<leader>bK", "<cmd>bufdo bwipeout<cr>", desc = "kill-buffer (all)" },
    { "<leader>bd", "<cmd>bdelete<cr>", desc = "delete-buffer" },
    { "<leader>bf", "<cmd>brewind<cr>", desc = "first-buffer" },
    { "<leader>bk", "<cmd>bwipeout<cr>", desc = "kill-buffer" },
    { "<leader>bl", "<cmd>blast<cr>", desc = "last-buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "next-buffer" },
    { "<leader>bp", "<cmd>bprev<cr>", desc = "previous-buffer" },
    { "<leader>br", "<cmd>Telescope treesitter theme=dropdown<cr>", desc = "find-treesitter" },
    { "<leader>bs", "<cmd>Telescope buffers theme=dropdown<cr>", desc = "find-buffer" },
})
