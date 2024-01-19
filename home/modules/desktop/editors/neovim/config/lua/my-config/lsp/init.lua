vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

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
            "<cmd>lua vim.lsp.buf.code_action()<CR>",
            "code-action",
        },
        e = {
            name = "code-lens",
            r = { "<Cmd>lua vim.lsp.codelens.refresh()<CR>", "refresh" },
            a = { "<Cmd>lua vim.lsp.codelens.run()<CR>", "run" },
        },
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename" },
    },
}, { prefix = "<leader>" })

wk.register({
    l = {
        name = "lsp",
        a = {
            ":<C-U>lua vim.lsp.buf.range_code_action()<CR>",
            "range-code-action",
        },
    },
}, { mode = "v", prefix = "<leader>" })

vim.cmd("nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>")
vim.cmd("nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>")
vim.cmd("nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>")
vim.cmd("nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>")

-- jump
vim.cmd("nnoremap <silent> <C-p> <cmd>lua vim.diagnostic.goto_prev({})<CR>")
vim.cmd("nnoremap <silent> <C-n> <cmd>lua vim.diagnostic.goto_next({})<CR>")

return lsp_config
