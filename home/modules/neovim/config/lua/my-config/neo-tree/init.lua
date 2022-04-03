vim.g.neo_tree_remove_legacy_commands = 1
require("neo-tree").setup({})

local wk = require("which-key")
wk.register({
	f = {
		name = "find/files",
		d = { "<cmd>Neotree reveal<cr>", "find-current-buffer-in-tree" },
		t = { "<cmd>Neotree toggle<cr>", "toggle-tree" },
	},
}, { prefix = "<leader>" })

wk.register({
	b = {
		name = "buffer",
		t = { "<cmd>Neotree buffers toggle<cr>", "toggle-tree" },
	},
}, { prefix = "<leader>" })
