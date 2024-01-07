require("smart-splits").setup({
    disable_multiplexer_nav_when_zoomed = false,
}) -- recommended mappings

local wk = require("which-key")

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
wk.register({
    ["<A-h>"] = { require("smart-splits").resize_left, "resize-buffer-left" },
    ["<A-j>"] = { require("smart-splits").resize_down, "resize-buffer-down" },
    ["<A-k>"] = { require("smart-splits").resize_up, "resize-buffer-up" },
    ["<A-l>"] = { require("smart-splits").resize_right, "resize-buffer-right" },
})

-- moving between splits
wk.register({
    ["<C-h>"] = { require("smart-splits").move_cursor_left, "move-cursor-left" },
    ["<C-j>"] = { require("smart-splits").move_cursor_down, "move-cursor-down" },
    ["<C-k>"] = { require("smart-splits").move_cursor_up, "move-cursor-up" },
    ["<C-l>"] = { require("smart-splits").move_cursor_right, "move-cursor-right" },
})

-- swapping buffers between windows
wk.register({
    ["<leader>"] = {
        name = "splits",
        h = { require("smart-splits").swap_buf_left, "swap-buffer-left" },
        j = { require("smart-splits").swap_buf_down, "swap-buffer-down" },
        k = { require("smart-splits").swap_buf_up, "swap-buffer-up" },
        l = { require("smart-splits").swap_buf_right, "swap-buffer-right" },
    },
}, { prefix = "<leader>" })
