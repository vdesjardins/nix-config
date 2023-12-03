OpenTerminalPane = function(file)
    local file_name = file
    if file_name == nil then
        file_name = vim.api.nvim_buf_get_name(0)
    end

    local file_path
    if vim.fn.isdirectory(file_name) ~= 0 then
        file_path = file_name
    else
        file_path = vim.fs.dirname(file_name)
    end

    vim.cmd("ToggleTerm dir=" .. file_path)
end

require("toggleterm").setup()

local wk = require("which-key")
wk.register({
    p = {
        T = { "<cmd>ToggleTerm<cr>", "toggle-terminal" },
    },
}, { prefix = "<leader>" })

wk.register({
    b = {
        T = { "<cmd>lua OpenTerminalPane()<cr>", "terminal" },
    },
}, { prefix = "<leader>" })
