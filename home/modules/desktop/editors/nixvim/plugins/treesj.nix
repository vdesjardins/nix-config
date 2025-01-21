{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      treesj
    ];

    extraConfigLua = ''
      require('treesj').setup({
        use_default_keymaps = false,
      })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>lj";
        action = "<cmd>TSJToggle<cr>";
        options.desc = "Toggle Split/Join (treesj)";
      }
    ];
  };
}
