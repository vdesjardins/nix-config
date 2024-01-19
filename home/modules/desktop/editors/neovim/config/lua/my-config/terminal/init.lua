local function url_encode(str)
    if str then
        str = str:gsub("\n", "\r\n")
        str = str:gsub("([^%w %-%_%.%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = str:gsub(" ", "+")
    end
    return str
end

local function _osc_cwd()
    local hostname = vim.fn.hostname()
    local cwd = vim.fn.getcwd()
    local encoded_cwd = url_encode(cwd)

    -- set current directory in terminal
    local osc7_seq = string.format("\027]7;file://%s/%s\027\\", hostname, encoded_cwd)

    io.write(osc7_seq)

    -- set tab name in terminal
    local cwdDirname = vim.fn.fnamemodify(cwd, ":t")

    local osc1_seq = string.format("\x1b]1; %s \x1b\\", cwdDirname)

    io.write(osc1_seq)
end

-- Set up the autocmd to run the function whenever the directory changes
local group = vim.api.nvim_create_augroup("OSC", { clear = true })
vim.api.nvim_create_autocmd("DirChanged", { group = group, pattern = "*", callback = _osc_cwd })
