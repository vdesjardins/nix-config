local wk = require("which-key")

local function addFile()
    local f = vim.api.nvim_buf_get_name(0)
    vim.cmd("Git add " .. f)
end

wk.register({
    g = {
        name = "git",
        a = { addFile, "fugitive-add" },
        c = { "<cmd>Git commit<cr>", "fugitive-commit" },
        d = { "<cmd>Gdiffsplit<cr>", "fugitive-diff" },
        e = { "<cmd>Gedit<cr>", "fugitive-edit" },
        l = { "<cmd>Gclog<cr>", "fugitive-log" },
        r = { "<cmd>Gread<cr>", "fugitive-read" },
        s = { "<cmd>Git<cr>", "fugitive-status" },
        w = { "<cmd>Gwrite<cr>", "fugitive-write" },
        p = { "<cmd>Git push<cr>", "fugitive-push" },
        P = { "<cmd>Git pull<cr>", "fugitive-pull" },
        f = { "<cmd>diffget //2<cr>", "diff-get-left" },
        j = { "<cmd>diffget //3<cr>", "diff-get-right" },
    },
}, { prefix = "<leader>" })
