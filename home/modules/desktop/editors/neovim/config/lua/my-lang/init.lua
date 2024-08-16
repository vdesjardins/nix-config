vim.cmd("autocmd BufWritePre * lua _G.LangFormatBuffer()")

function _G.LangFormatBuffer()
    local buf_ft = vim.bo.filetype
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            vim.lsp.buf.format({ timeout_ms = 1500 })
            return
        end
    end
end
