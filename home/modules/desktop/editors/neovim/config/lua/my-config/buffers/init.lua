local wk = require("which-key")
wk.register({
    b = {
        name = "buffer",
        d = { "<cmd>bdelete<cr>", "delete-buffer" },
        D = { "<cmd>bufdo bdelete<cr>", "delete-buffer (all)" },
        f = { "<cmd>brewind<cr>", "first-buffer" },
        k = { "<cmd>bwipeout<cr>", "kill-buffer" },
        K = { "<cmd>bufdo bwipeout<cr>", "kill-buffer (all)" },
        l = { "<cmd>blast<cr>", "last-buffer" },
        n = { "<cmd>bnext<cr>", "next-buffer" },
        p = { "<cmd>bprev<cr>", "previous-buffer" },
        s = { "<cmd>Telescope buffers theme=dropdown<cr>", "find-buffer" },
        r = { "<cmd>Telescope treesitter theme=dropdown<cr>", "find-treesitter" },
    },
}, { prefix = "<leader>" })
