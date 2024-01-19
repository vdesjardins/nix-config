require("dapui").setup()

local wk = require("which-key")
wk.register({
    d = {
        name = "debugging",
        o = { '<cmd>lua require("dapui").open()<cr>', "open" },
        c = { '<cmd>lua require("dapui").close()<cr>', "close" },
        t = { '<cmd>lua require("dapui").close()<cr>', "toggle" },
        b = {
            '<cmd>lua require("dap").toggle_breakpoint()<cr>',
            "toggle breakpoint",
        },
        B = {
            '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',
            "set breakpoint with condition",
        },
        l = {
            name = "logging",
            p = {
                '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>',
                "log point message",
            },
        },
        d = {
            name = "debugging",
            r = {
                '<cmd>lua require("dap").repl.open()<cr>',
                "repl",
            },
        },
        r = { '<cmd>lua require("dap").continue()<cr>', "continue" },
        n = { '<cmd>lua require("dap").step_over()<cr>', "step over" },
        s = { '<cmd>lua require("dap").step_into()<cr>', "step into" },
        e = { '<cmd>lua require("dap").step_out()<cr>', "step out" },
    },
}, { prefix = "<leader>" })
