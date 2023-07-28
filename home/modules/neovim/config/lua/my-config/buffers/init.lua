local wk = require("which-key")
wk.register({
    b = {
        name = "buffer",
        d = { "<cmd>Bdelete<cr>", "delete-buffer" },
        f = { "<cmd>brewind<cr>", "first-buffer" },
        k = { "<cmd>Bwipeout<cr>", "kill-buffer" },
        l = { "<cmd>blast<cr>", "last-buffer" },
        n = { "<cmd>bnext<cr>", "next-buffer" },
        p = { "<cmd>bprev<cr>", "previous-buffer" },
        s = { "<cmd>Telescope buffers theme=dropdown<cr>", "find-buffer" },
        r = { "<cmd>Telescope treesitter theme=dropdown<cr>", "find-treesitter" },
    },
}, { prefix = "<leader>" })
