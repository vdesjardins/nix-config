{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) genList;
  inherit (builtins) toString;
in {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      grapple-nvim
    ];

    extraConfigLua = ''
      require("grapple").setup({})
    '';

    keymaps =
      [
        {
          mode = "n";
          key = "<leader>gm";
          action = "<cmd>Grapple tag<cr>";
          options.desc = "Toggle Tag (Grapple)";
        }
        {
          mode = "n";
          key = "<leader>g/";
          action = "<cmd>Grapple toggle_tags<cr>";
          options.desc = "Open Tags Window (Grapple)";
        }
        {
          mode = "n";
          key = "g/";
          action = "<cmd>Grapple toggle_tags<cr>";
          options.desc = "Open Tags Window (Grapple)";
        }
        {
          mode = "n";
          key = "<leader>gn";
          action = "<cmd>Grapple cycle_tags next<cr>";
          options.desc = "Cycle Tags Next (Grapple)";
        }
        {
          mode = "n";
          key = "<leader>gp";
          action = "<cmd>Grapple cycle_tags prev<cr>";
          options.desc = "Cycle Tags Previous (Grapple)";
        }
      ]
      ++ genList (i: let
        idx = toString (i + 1);
      in {
        mode = "n";
        key = "g${idx}";
        action = "<cmd>Grapple select index=${idx}<cr>";
        options.desc = "Goto Tag ${idx} (Grapple)";
      })
      9;
  };
}
