{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap = {
      enable = true;

      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };

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
        options.desc = "toggle breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "close";
      }
      {
        mode = "n";
        key = "<leader>ddr";
        action = "<cmd>lua require('dap').repl.open()<cr>";
        options.desc = "repl";
      }
      {
        mode = "n";
        key = "<leader>de";
        action = "<cmd>lua require('dap').step_out()<cr>";
        options.desc = "step out";
      }
      {
        mode = "n";
        key = "<leader>dlp";
        action = "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>";
        options.desc = "log point message";
      }
      {
        mode = "n";
        key = "<leader>dn";
        action = "<cmd>lua require('dap').step_over()<cr>";
        options.desc = "step over";
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua require('dapui').open()<cr>";
        options.desc = "open";
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require('dap').continue()<cr>";
        options.desc = "continue";
      }
      {
        mode = "n";
        key = "<leader>ds";
        action = "<cmd>lua require('dap').step_into()<cr>";
        options.desc = "step into";
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "toggle";
      }
    ];
  };
}
