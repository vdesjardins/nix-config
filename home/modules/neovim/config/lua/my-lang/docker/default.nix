{ pkgs, ... }: {
  packages = with pkgs; [
    nodePackages.dockerfile-language-server-nodejs
    hadolint
  ];
}

