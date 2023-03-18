OpenTmuxTerminalPane = function()
    local file_name = vim.api.nvim_buf_get_name(0)
    local file_path = vim.fs.dirname(file_name)
    vim.cmd("!$SHELL -c 'cd " .. file_path .. "&& tmux split-window -v'")
end

local wk = require("which-key")
wk.register({
    f = {
        name = "find/files",
        o = { "<cmd>lua OpenTmuxTerminalPane()<cr>", "open-terminal" },
    },
}, { prefix = "<leader>" })
