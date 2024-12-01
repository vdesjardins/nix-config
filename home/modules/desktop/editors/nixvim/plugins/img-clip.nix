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
        require("img-clip").setup({
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
        },
        })
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
