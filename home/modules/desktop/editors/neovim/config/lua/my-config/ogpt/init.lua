require("ogpt").setup({
    debug = {
        log_level = 0,
    },

    edgy = true,
    single_window = false,

    default_provider = "ollama",
    providers = {
        ollama = {
            model = {
                name = "llama3:latest",
            },
        },
    },
})

local wk = require("which-key")
wk.register({
    c = {
        name = "Chat ollama",
        c = { "<cmd>OGPT<CR>", "OGPT" },
        A = { "<cmd>OGPTActAs<cr>", "Act As" },
        e = {
            "<cmd>OGPTRun edit_code_with_instructions<CR>",
            "Edit code with instructions",
            mode = { "n", "v" },
        },
        g = { "<cmd>OGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
        t = { "<cmd>OGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
        k = { "<cmd>OGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
        d = { "<cmd>OGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
        a = { "<cmd>OGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
        o = { "<cmd>OGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
        s = { "<cmd>OGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
        f = { "<cmd>OGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
        x = { "<cmd>OGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
        r = { "<cmd>OGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
        l = {
            "<cmd>OGPTRun code_readability_analysis<CR>",
            "Code Readability Analysis",
            mode = { "n", "v" },
        },
    },
}, { prefix = "<leader>" })
