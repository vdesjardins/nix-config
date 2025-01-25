{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>xn";
        action = "<cmd>cnext<cr>";
        options.desc = "Next (Quickfix)";
      }
      {
        key = "<leader>xp";
        action = "<cmd>cprevious<cr>";
        options.desc = "Previous (Quickfix)";
      }
      {
        key = "<leader>xc";
        action = "<cmd>cclose<cr>";
        options.desc = "Close (Quickfix)";
      }
      {
        key = "<leader>xo";
        action = "<cmd>copen<cr>";
        options.desc = "Open (Quickfix)";
      }
      {
        mode = "n";
        key = "<leader>xd";
        action.__raw = "Snacks.picker.diagnostics";
        options.desc = "Diagnostics in Project(Snacks)";
      }
      {
        mode = "n";
        key = "<leader>xD";
        action.__raw = "Snacks.picker.diagnostics_buffer";
        options.desc = "Diagnostics in Current Buffer (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>xq";
        action.__raw = "Snacks.picker.qflist";
        options.desc = "Quickfix (Snacks)";
      }
    ];
  };
}
