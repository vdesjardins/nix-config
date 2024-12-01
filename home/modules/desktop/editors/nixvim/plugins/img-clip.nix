{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      img-clip-nvim
    ];

    extraConfigLua =
      # lua
      ''
        require("img-clip").setup({})
      '';
  };

  home.packages =
    lib.optionals pkgs.stdenv.isDarwin [
      pkgs.pngpaste
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.wl-clipboard
    ];
}
