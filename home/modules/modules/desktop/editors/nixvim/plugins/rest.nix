{
  programs.nixvim = {
    plugins.rest = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ro";
        action = "<cmd>Rest open<cr>";
        options.desc = "Open (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rr";
        action = "<cmd>Rest run<cr>";
        options.desc = "Run Request (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>Rest run ";
        options.desc = "Run Request Name (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rl";
        action = "<cmd>Rest last<cr>";
        options.desc = "Run Last Request (Rest)";
      }
      {
        mode = "n";
        key = "<leader>re";
        action = "<cmd>Rest env show<cr>";
        options.desc = "Show Env (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rc";
        action = "<cmd>Rest env select<cr>";
        options.desc = "Select Env (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rs";
        action = "<cmd>Rest env set ";
        options.desc = "Set Env (Rest)";
      }
      {
        mode = "n";
        key = "<leader>rC";
        action = "<cmd>Rest cookies<cr>";
        options.desc = "Edit Cookies (Rest)";
      }
    ];
  };
}
