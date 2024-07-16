vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

vim.lsp.inlay_hint.enable()

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    " ﴲ  (Field)",
    "[] (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    " ﬌  (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)",
}

local function documentHighlight(client, _bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec(
            [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
            false
        )
    end
end

local function noDocumentFormatting(client, _bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local lsp_config = {}

function lsp_config.common_on_attach(client, bufnr)
    documentHighlight(client, bufnr)
end

function lsp_config.common_on_attach_no_formatting(client, bufnr)
    documentHighlight(client, bufnr)
    noDocumentFormatting(client, bufnr)
end

vim.fn.sign_define("DiagnosticSignError", {
    text = " ",
    numhl = "DiagnosticSignError",
    texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
    text = " ",
    numhl = "DiagnosticSignWarn",
    texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignInfo", {
    text = " ",
    numhl = "DiagnosticSignInfo",
    texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DiagnosticSignHint", {
    text = " ",
    numhl = "DiagnosticSignHint",
    texthl = "DiagnosticSignHint",
})

-- keybindings
local wk = require("which-key")
wk.add({
    { "<leader>l", group = "lsp" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code-action" },
    { "<leader>le", group = "code-lens" },
    { "<leader>lea", "<Cmd>lua vim.lsp.codelens.run()<CR>", desc = "run" },
    { "<leader>ler", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", desc = "refresh" },
    { "<leader>lg", group = "goto" },
    { "<leader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "go-to-declaration" },
    { "<leader>lgd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "go-to-definition" },
    { "<leader>lgi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "go-to-implementation" },
    { "<leader>lgr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "references" },
    {
        "<leader>li",
        "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
        desc = "toggle-inlay-hints",
    },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename" },
})

wk.add({
    { "<leader>l", group = "lsp", mode = "v" },
    {
        "<leader>la",
        ":<C-U>lua vim.lsp.buf.range_code_action()<CR>",
        desc = "range-code-action",
        mode = "v",
    },
})

vim.cmd("nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>")
vim.cmd("nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>")
vim.cmd("nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>")
vim.cmd("nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>")

-- jump
vim.cmd("nnoremap <silent> <C-p> <cmd>lua vim.diagnostic.goto_prev({})<CR>")
vim.cmd("nnoremap <silent> <C-n> <cmd>lua vim.diagnostic.goto_next({})<CR>")

return lsp_config
