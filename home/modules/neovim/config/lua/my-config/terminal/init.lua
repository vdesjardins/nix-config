OpenTmuxTerminalPane = function(file)
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

    vim.cmd("!$SHELL -c 'cd " .. file_path .. "&& tmux split-window -v'")
end

local wk = require("which-key")
wk.register({
    f = {
        name = "find/files",
        T = { "<cmd>lua OpenTmuxTerminalPane()<cr>", "terminal" },
    },
}, { prefix = "<leader>" })
