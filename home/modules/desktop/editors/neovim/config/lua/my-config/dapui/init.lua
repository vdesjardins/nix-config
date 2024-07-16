require("dapui").setup()

local wk = require("which-key")
wk.add({
    { "<leader>d", group = "debugging" },
    {
        "<leader>dB",
        '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',
        desc = "set breakpoint with condition",
    },
    {
        "<leader>db",
        '<cmd>lua require("dap").toggle_breakpoint()<cr>',
        desc = "toggle breakpoint",
    },
    { "<leader>dc", '<cmd>lua require("dapui").close()<cr>', desc = "close" },
    { "<leader>dd", group = "debugging" },
    { "<leader>ddr", '<cmd>lua require("dap").repl.open()<cr>', desc = "repl" },
    { "<leader>de", '<cmd>lua require("dap").step_out()<cr>', desc = "step out" },
    { "<leader>dl", group = "logging" },
    {
        "<leader>dlp",
        '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>',
        desc = "log point message",
    },
    { "<leader>dn", '<cmd>lua require("dap").step_over()<cr>', desc = "step over" },
    { "<leader>do", '<cmd>lua require("dapui").open()<cr>', desc = "open" },
    { "<leader>dr", '<cmd>lua require("dap").continue()<cr>', desc = "continue" },
    { "<leader>ds", '<cmd>lua require("dap").step_into()<cr>', desc = "step into" },
    { "<leader>dt", '<cmd>lua require("dapui").close()<cr>', desc = "toggle" },
})
