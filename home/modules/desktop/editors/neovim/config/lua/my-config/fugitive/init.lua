local wk = require("which-key")

local function addFile()
    local f = vim.api.nvim_buf_get_name(0)
    vim.cmd("Git add " .. f)
end

wk.add({
    { "<leader>g", group = "git" },
    { "<leader>gP", "<cmd>Git pull<cr>", desc = "fugitive-pull" },
    { "<leader>ga", addFile, desc = "fugitive-add" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "fugitive-commit" },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "fugitive-diff" },
    { "<leader>ge", "<cmd>Gedit<cr>", desc = "fugitive-edit" },
    { "<leader>gf", "<cmd>diffget //2<cr>", desc = "diff-get-left" },
    { "<leader>gj", "<cmd>diffget //3<cr>", desc = "diff-get-right" },
    { "<leader>gl", "<cmd>Gclog<cr>", desc = "fugitive-log" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "fugitive-push" },
    { "<leader>gr", "<cmd>Gread<cr>", desc = "fugitive-read" },
    { "<leader>gs", "<cmd>Git<cr>", desc = "fugitive-status" },
    { "<leader>gw", "<cmd>Gwrite<cr>", desc = "fugitive-write" },
})
