{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      grapple-nvim
    ];

    extraConfigLua = ''
      require("grapple").setup({})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>gm";
        action = "<cmd>Grapple toggle<cr>";
        options.desc = "Toggle Tag (Grapple)";
      }
      {
        mode = "n";
        key = "<leader>gM";
        action = "<cmd>Grapple toggle_tags<cr>";
        options.desc = "Open Tags Window (Grapple)";
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>Grapple cycle_next<cr>";
        options.desc = "Cycle Next (Grapple)";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Grapple cycle_prev<cr>";
        options.desc = "Cycle Previous (Grapple)";
      }
    ];
  };
}
