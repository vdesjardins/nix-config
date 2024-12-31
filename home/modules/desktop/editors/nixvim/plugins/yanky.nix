{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>fy";
        action = "<cmd>YankyRingHistory<cr>";
        options.desc = "Yank History";
      }
    ];

    plugins = {
      yanky = {
        enable = true;
      };

      lspkind = {
        cmp = {
          menu = {
            cmp_yanky = "⧉";
          };
        };
      };

      cmp_yanky.enable = true;
    };
  };
}
