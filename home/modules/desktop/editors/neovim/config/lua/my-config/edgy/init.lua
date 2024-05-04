vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

require("edgy").setup({
    exit_when_last = false,
    animate = {
        enabled = false,
    },
    wo = {
        winbar = true,
        winfixwidth = true,
        winfixheight = false,
        winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
        spell = false,
        signcolumn = "no",
    },
    keys = {
        -- -- close window
        ["q"] = function(win)
            win:close()
        end,
        -- close sidebar
        ["Q"] = function(win)
            win.view.edgebar:close()
        end,
        -- increase width
        ["<S-Right>"] = function(win)
            win:resize("width", 3)
        end,
        -- decrease width
        ["<S-Left>"] = function(win)
            win:resize("width", -3)
        end,
        -- increase height
        ["<S-Up>"] = function(win)
            win:resize("height", 3)
        end,
        -- decrease height
        ["<S-Down>"] = function(win)
            win:resize("height", -3)
        end,
    },
    right = {
        {
            title = "OGPT Popup",
            ft = "ogpt-popup",
            size = { width = 0.2 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPT Parameters",
            ft = "ogpt-parameters-window",
            size = { height = 6 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPT Template",
            ft = "ogpt-template",
            size = { height = 6 },
        },
        {
            title = "OGPT Sessions",
            ft = "ogpt-sessions",
            size = { height = 6 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPT System Input",
            ft = "ogpt-system-window",
            size = { height = 6 },
        },
        {
            title = "OGPT",
            ft = "ogpt-window",
            size = { height = 0.5 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPT {{{selection}}}",
            ft = "ogpt-selection",
            size = { width = 80, height = 4 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPt {{{instruction}}}",
            ft = "ogpt-instruction",
            size = { width = 80, height = 4 },
            wo = {
                wrap = true,
            },
        },
        {
            title = "OGPT Chat",
            ft = "ogpt-input",
            size = { width = 80, height = 4 },
            wo = {
                wrap = true,
            },
        },
    },
})
