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

local wk = require("which-key")
wk.register({
    n = {
        name = "Notes",
        o = { "<cmd>ObsidianOpen<CR>", "Open" },
        t = { "<cmd>ObsidianToday<CR>", "Today" },
        y = { "<cmd>ObsidianYesterday<CR>", "Yesterday" },
        d = { "<cmd>ObsidianDailies<CR>", "Dailies" },
        n = { "<cmd>ObsidianNew<CR>", "New" },
        b = { "<cmd>ObsidianBacklinks<CR>", "Backlinks" },
        T = { "<cmd>ObsidianTags<CR>", "Tags" },
        s = { "<cmd>ObsidianSearch<CR>", "Search" },
        l = { "<cmd>ObsidianLinks<CR>", "Links" },
        p = { "<cmd>ObsidianPasteImg<CR>", "Paste image and link it" },
    },
}, { prefix = "<leader>" })

wk.register({
    l = { "<cmd>ObsidianLink<CR>", "Link" },
    L = { "<cmd>ObsidianLinkNew<CR>", "Link to new" },
    e = { "<cmd>ObsidianExtractNote<CR>", "Extract to new note and link it" },
}, { prefix = "<leader>", mode = "v" })
