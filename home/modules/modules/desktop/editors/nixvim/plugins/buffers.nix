{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>BD";
      action = "<cmd>bufdo bdelete<cr>";
      options.desc = "Delete Buffer (all)";
    }
    {
      mode = "n";
      key = "<leader>BK";
      action = "<cmd>bufdo bwipeout<cr>";
      options.desc = "Kill Buffer (all)";
    }
    {
      mode = "n";
      key = "<leader>Bd";
      action = "<cmd>bdelete<cr>";
      options.desc = "Delete Buffer";
    }
    {
      mode = "n";
      key = "<leader>Bf";
      action = "<cmd>brewind<cr>";
      options.desc = "First Buffer";
    }
    {
      mode = "n";
      key = "<leader>Bw";
      action = "<cmd>bwipeout<cr>";
      options.desc = "Kill Buffer (wipeout)";
    }
    {
      mode = "n";
      key = "<leader>BL";
      action = "<cmd>blast<cr>";
      options.desc = "Last Buffer";
    }
    {
      mode = "n";
      key = "<leader>BN";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
    }
    {
      mode = "n";
      key = "<leader>BP";
      action = "<cmd>bprev<cr>";
      options.desc = "Previous Buffer";
    }
    {
      mode = "n";
      key = "<leader>Bc";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear Highlight";
    }
  ];
}
