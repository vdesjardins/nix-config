require("rust-tools").setup({
	tools = {
		autoSetHints = true,
		runnables = { use_telescope = true },
		inlay_hints = { show_parameter_hints = true },
		hover_actions = { auto_focus = true },
	},

	server = { flags = { debounce_text_changes = 150 } },
})
