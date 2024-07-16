require("smart-splits").setup({
    disable_multiplexer_nav_when_zoomed = false,
}) -- recommended mappings

local wk = require("which-key")

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
wk.add({
    { "<A-h>", require("smart-splits").resize_left, desc = "resize-buffer-left" },
    { "<A-j>", require("smart-splits").resize_down, desc = "resize-buffer-down" },
    { "<A-k>", require("smart-splits").resize_up, desc = "resize-buffer-up" },
    { "<A-l>", require("smart-splits").resize_right, desc = "resize-buffer-right" },
})

-- moving between splits
wk.add({
    { "<C-h>", require("smart-splits").move_cursor_left, desc = "move-cursor-left" },
    { "<C-j>", require("smart-splits").move_cursor_down, desc = "move-cursor-down" },
    { "<C-k>", require("smart-splits").move_cursor_up, desc = "move-cursor-up" },
    { "<C-l>", require("smart-splits").move_cursor_right, desc = "move-cursor-right" },
})

-- swapping buffers between windows
wk.add({
    { "<leader>", group = "splits" },
    { "<leader>h", require("smart-splits").swap_buf_left, desc = "swap-buffer-left" },
    { "<leader>j", require("smart-splits").swap_buf_down, desc = "swap-buffer-down" },
    { "<leader>k", require("smart-splits").swap_buf_up, desc = "swap-buffer-up" },
    { "<leader>l", require("smart-splits").swap_buf_right, desc = "swap-buffer-right" },
})
