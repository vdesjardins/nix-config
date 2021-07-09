local wk = require("which-key")
wk.register({
  l = {
    name = "lsp",
    g = {
      name = "goto",
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "go-to-definition" },
      D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "go-to-declaration" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "go-to-implementation" },
      r = { "<cmd>lua vim.lsp.buf.references()<cr>", "references" },
    },
    a = {
      "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
      "code-action",
    },
    R = {
      ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>",
      "range-code-action",
    },
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
    t = {
      name = "trouble",
      x = { "<cmd>LspTroubleToggle<cr>", "trouble" },
      w = {
        "<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>",
        "trouble-workspace-diagnostics",
      },
      d = {
        "<cmd>LspTroubleToggle lsp_document_diagnostics<cr>",
        "trouble-document-diagnostics",
      },
      q = { "<cmd>LspTroubleToggle quickfix<cr>", "trouble-quickfix" },
      l = { "<cmd>LspTroubleToggle loclist<cr>", "trouble-loclist" },
      r = { "<cmd>LspTroubleToggle lsp_references<cr>", "trouble-references" },
    },
  },
}, { prefix = "<leader>" })

-- jump
vim.cmd("nnoremap <silent> <C-p> :Lspsaga diagnostic_jump_prev<CR>")
vim.cmd("nnoremap <silent> <C-n> :Lspsaga diagnostic_jump_next<CR>")

-- scroll down hover doc or scroll in definition preview
vim.cmd(
  "nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
-- scroll up hover doc
vim.cmd(
  "nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
--
vim.cmd(
  "nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")

vim.cmd("nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>")
vim.cmd("nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>")
vim.cmd("nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>")
vim.cmd("nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>")
