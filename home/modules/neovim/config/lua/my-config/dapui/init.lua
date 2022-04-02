require("dapui").setup()

local wk = require("which-key")
wk.register({
	d = {
		name = "debugging",
		o = { '<cmd>lua require("dapui").open()<cr>', "open" },
		c = { '<cmd>lua require("dapui").close()<cr>', "close" },
		t = { '<cmd>lua require("dapui").close()<cr>', "toggle" },
		b = {
			'<cmd>lua require("dap").toggle_breakpoint()<cr>',
			"toggle breakpoint",
		},
		r = { '<cmd>lua require("dap").continue()<cr>', "continue" },
		n = { '<cmd>lua require("dap").step_over()<cr>', "step over" },
		s = { '<cmd>lua require("dap").step_into()<cr>', "step into" },
		e = { '<cmd>lua require("dap").step_out()<cr>', "step out" },
	},
}, { prefix = "<leader>" })
