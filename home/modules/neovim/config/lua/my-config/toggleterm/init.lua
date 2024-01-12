local openTerminalPane = function(file)
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

local toggleterm = require("toggleterm")
toggleterm.setup()

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "n",
            "q",
            "<cmd>close<CR>",
            { noremap = true, silent = true }
        )
    end,
    -- function to run on closing the terminal
    on_close = function(_term)
        vim.cmd("startinsert!")
    end,
})

local function lazygit_toggle()
    lazygit:toggle()
end

local wk = require("which-key")
wk.register({
    p = {
        T = { "<cmd>ToggleTerm<cr>", "toggle-terminal" },
    },
}, { prefix = "<leader>" })

wk.register({
    b = {
        T = { openTerminalPane, "terminal" },
    },
}, { prefix = "<leader>" })
wk.register({
    g = {
        y = { lazygit_toggle, "lazygit" },
    },
}, { prefix = "<leader>" })
wk.register({
    s = {
        function()
            local tsel = "visual_selection"
            if vim.fn.mode():sub(1, 1) == "V" then
                tsel = "visual_lines"
            end
            toggleterm.send_lines_to_terminal(tsel, true, { args = vim.v.count })
        end,
        "send-selection-terminal",
    },
}, { prefix = "<leader>", mode = "v" })
