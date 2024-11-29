{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>xn";
        action = "<cmd>cnext<cr>";
        options.desc = "Next (Quckfix)";
      }
      {
        key = "<leader>xp";
        action = "<cmd>cprevious<cr>";
        options.desc = "Previous (Quckfix)";
      }
    ];
  };
}
