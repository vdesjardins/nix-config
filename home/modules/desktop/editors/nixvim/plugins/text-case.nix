{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      text-case-nvim
    ];
    extraConfigLua =
      # lua
      ''
        require('textcase').setup({})
        require("telescope").load_extension("textcase")
      '';

    keymaps = [
      {
        mode = "n";
        key = "ga.";
        action = "<cmd>TextCaseOpenTelescope<cr>";
        options.desc = "Text Case (Telescope)";
      }
      {
        mode = "x";
        key = "ga.";
        action = "<cmd>TextCaseOpenTelescope<cr>";
        options.desc = "Text Case (Telescope)";
      }
    ];
  };
}
