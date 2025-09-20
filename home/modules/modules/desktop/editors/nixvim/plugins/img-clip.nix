{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins.img-clip = {
    enable = true;
    settings = {
      embed_image_as_base64 = false;
      prompt_for_file_name = false;
      drag_and_drop = {
        insert_mode = true;
      };
    };
  };

  home.packages =
    lib.optionals pkgs.stdenv.isDarwin [
      # pkgs.pngpaste
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.wl-clipboard
    ];
}
