{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap = {
      enable = true;

      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };

    extraConfigLua = ''
      vim.fn.sign_define("DapBreakpoint", { text = "● ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "● ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "● ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→ ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointReject", { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>dB";
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
        options.desc = "set breakpoint with condition";
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
        options.desc = "Toggle Breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "Close";
      }
      {
        mode = "n";
        key = "<leader>ddr";
        action = "<cmd>lua require('dap').repl.open()<cr>";
        options.desc = "Repl";
      }
      {
        mode = "n";
        key = "<leader>de";
        action = "<cmd>lua require('dap').step_out()<cr>";
        options.desc = "Step Out";
      }
      {
        mode = "n";
        key = "<leader>dlp";
        action = "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>";
        options.desc = "Log Point Message";
      }
      {
        mode = "n";
        key = "<leader>dn";
        action = "<cmd>lua require('dap').step_over()<cr>";
        options.desc = "Step Over";
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua require('dapui').open()<cr>";
        options.desc = "Open";
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require('dap').continue()<cr>";
        options.desc = "Continue";
      }
      {
        mode = "n";
        key = "<leader>ds";
        action = "<cmd>lua require('dap').step_into()<cr>";
        options.desc = "Step Into";
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "Toggle";
      }
    ];
  };
}
