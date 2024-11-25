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
        key = "<leader>dB";
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
        options.desc = "set breakpoint with condition";
      }
      {
        key = "<leader>db";
        action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
        options.desc = "toggle breakpoint";
      }
      {
        key = "<leader>dc";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "close";
      }
      {
        key = "<leader>ddr";
        action = "<cmd>lua require('dap').repl.open()<cr>";
        options.desc = "repl";
      }
      {
        key = "<leader>de";
        action = "<cmd>lua require('dap').step_out()<cr>";
        options.desc = "step out";
      }
      {
        key = "<leader>dlp";
        action = "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>";
        options.desc = "log point message";
      }
      {
        key = "<leader>dn";
        action = "<cmd>lua require('dap').step_over()<cr>";
        options.desc = "step over";
      }
      {
        key = "<leader>do";
        action = "<cmd>lua require('dapui').open()<cr>";
        options.desc = "open";
      }
      {
        key = "<leader>dr";
        action = "<cmd>lua require('dap').continue()<cr>";
        options.desc = "continue";
      }
      {
        key = "<leader>ds";
        action = "<cmd>lua require('dap').step_into()<cr>";
        options.desc = "step into";
      }
      {
        key = "<leader>dt";
        action = "<cmd>lua require('dapui').close()<cr>";
        options.desc = "toggle";
      }
    ];
  };
}
