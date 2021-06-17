{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    buildkit
    dive
    nodePackages.dockerfile-language-server-nodejs
    hadolint
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins;
      [
        # Dockerfile-vim
      ];
  };
}
