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
wk.add({
    { "<leader>c", group = "Chat ollama" },
    { "<leader>cA", "<cmd>OGPTActAs<cr>", desc = "Act As" },
    { "<leader>cc", "<cmd>OGPT<CR>", desc = "OGPT" },
    {
        mode = { "n", "v" },
        { "<leader>ca", "<cmd>OGPTRun add_tests<CR>", desc = "Add Tests" },
        { "<leader>cd", "<cmd>OGPTRun docstring<CR>", desc = "Docstring" },
        {
            "<leader>ce",
            "<cmd>OGPTRun edit_code_with_instructions<CR>",
            desc = "Edit code with instructions",
        },
        { "<leader>cf", "<cmd>OGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
        { "<leader>cg", "<cmd>OGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
        { "<leader>ck", "<cmd>OGPTRun keywords<CR>", desc = "Keywords" },
        {
            "<leader>cl",
            "<cmd>OGPTRun code_readability_analysis<CR>",
            desc = "Code Readability Analysis",
        },
        { "<leader>co", "<cmd>OGPTRun optimize_code<CR>", desc = "Optimize Code" },
        { "<leader>cr", "<cmd>OGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
        { "<leader>cs", "<cmd>OGPTRun summarize<CR>", desc = "Summarize" },
        { "<leader>ct", "<cmd>OGPTRun translate<CR>", desc = "Translate" },
        { "<leader>cx", "<cmd>OGPTRun explain_code<CR>", desc = "Explain Code" },
    },
})
