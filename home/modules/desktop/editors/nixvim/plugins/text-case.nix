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
      {
        mode = "n";
        key = "gat";
        action = "<cmd>lua require('textcase').operator('to_title_case')<cr>";
        options.desc = "Convert to Title Case";
      }
      {
        mode = "x";
        key = "gat";
        action = "<cmd>lua require('textcase').operator('to_title_case')<cr>";
        options.desc = "Convert to Title Case";
      }
    ];
  };
}
