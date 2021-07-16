{ pkgs, ... }: {
  home.packages = with pkgs; [
    buildkit
    dive
    nodePackages.dockerfile-language-server-nodejs
    hadolint
  ];
}
