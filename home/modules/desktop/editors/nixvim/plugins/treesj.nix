{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      treesj
    ];

    extraConfigLua =
      # lua
      ''
        require('treesj').setup({
          use_default_keymaps = false,
        })
      '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>lt";
        action = "<cmd>TSJToggle<cr>";
        options.desc = "Toggle Split/Join (treesj)";
      }
    ];
  };
}
