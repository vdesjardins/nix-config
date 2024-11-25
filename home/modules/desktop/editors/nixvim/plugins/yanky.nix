{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>fy";
        action = "<cmd>Telescope yank_history<cr>";
        options.desc = "Yank History";
      }
    ];

    plugins = {
      yanky = {
        enable = true;
        enableTelescope = true;
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
