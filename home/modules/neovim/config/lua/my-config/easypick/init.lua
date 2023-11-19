local easypick = require("easypick")

local list_make_targets = [[
sed -n 's/^##//p' Makefile | column -t -s ':' |  sed -e 's/^/ /'
]]

easypick.setup({
    pickers = {
        -- list modified files
        {
            name = "modified_files",
            command = "git diff --name-only --relative",
            previewer = easypick.previewers.file_diff(),
            opts = require("telescope.themes").get_dropdown({}),
        },

        -- list files that have conflicts with diffs in preview
        {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
            opts = require("telescope.themes").get_dropdown({}),
        },

        -- list make targets to exec
        {
            name = "make_targets",
            command = list_make_targets,
            action = easypick.actions.nvim_commandf("FloatermNew make %s"),
            opts = require("telescope.themes").get_dropdown({}),
        },
    },
})

local wk = require("which-key")
wk.register({
    p = {
        name = "projects",
        m = { "<cmd>Easypick modified_files<cr>", "files-modified" },
        c = { "<cmd>Easypick conflicts<cr>", "file-conflicts" },
        x = { "<cmd>Easypick make_targets<cr>", "make-targets" },
    },
}, { prefix = "<leader>" })
