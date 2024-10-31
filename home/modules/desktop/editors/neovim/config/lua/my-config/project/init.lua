require("project_nvim").setup()
require("telescope").load_extension("projects")

local wk = require("which-key")
wk.add({
    {
        "<leader>pp",
        require("telescope").extensions.projects.projects,
        desc = "pick project",
    },
})
