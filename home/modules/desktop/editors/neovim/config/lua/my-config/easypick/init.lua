local easypick = require("easypick")

local list_make_targets = [[
sed -n 's/^##//p' Makefile | column -t -s ':' |  sed -e 's/^/ /'
]]

easypick.setup({
    pickers = {
        -- list modified files
        {
            name = "modified_files",
            command = "git diff --name-only --diff-filter=d; git diff --name-only --cached; git ls-files --exclude-standard -o",
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
wk.add({
    { "<leader>p", group = "projects" },
    { "<leader>pc", "<cmd>Easypick conflicts<cr>", desc = "file-conflicts" },
    { "<leader>pm", "<cmd>Easypick modified_files<cr>", desc = "files-modified" },
    { "<leader>px", "<cmd>Easypick make_targets<cr>", desc = "make-targets" },
})
