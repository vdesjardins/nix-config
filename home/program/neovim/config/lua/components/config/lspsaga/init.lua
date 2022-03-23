local saga = require("lspsaga")

saga.init_lsp_saga({
	error_sign = "", -- ''
	warn_sign = "",
	hint_sign = "",
	infor_sign = "",
})

local wk = require("which-key")
wk.register({
	l = {
		name = "lsp",
		h = { "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", "hover" },
		f = { "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", "finder" },
		s = {
			"<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
			"signature",
		},
		m = { "<cmd>lua require('lspsaga.rename').rename()<CR>", "rename" },
		p = {
			"<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
			"preview-definition",
		},
		l = {
			"<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<cr>",
			"show-line-diagnostics",
		},
		c = {
			"<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<cr>",
			"show-cursor-diagnostics",
		},
	},
}, { prefix = "<leader>" })

-- jump
vim.cmd("nnoremap <silent> <C-p> :Lspsaga diagnostic_jump_prev<CR>")
vim.cmd("nnoremap <silent> <C-n> :Lspsaga diagnostic_jump_next<CR>")

-- scroll down hover doc or scroll in definition preview
vim.cmd("nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
-- scroll up hover doc
vim.cmd("nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
--
vim.cmd("nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
