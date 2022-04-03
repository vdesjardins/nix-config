local wk = require("which-key")
wk.register({
	f = {
		name = "find/files",
		s = { "<cmd>write<cr>", "save-file" },
		S = { "<cmd>w !sudo tee % > /dev/null<cr>", "save-file-sudo" },
	},
}, { prefix = "<leader>" })
