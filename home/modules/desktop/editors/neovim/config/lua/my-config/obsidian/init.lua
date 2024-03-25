require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/vaults/personal",
        },
        {
            name = "work",
            path = "~/vaults/work",
        },
    },

    notes_subdir = "Notes",

    daily_notes = {
        folder = "Notes/dailies",
    },
})
