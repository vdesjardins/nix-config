{ pkgs, ... }: {
  programs.myNeovim.lang.yaml = true;

  home.packages = with pkgs; [
    nodePackages.yaml-language-server
    yamllint
  ];

  imports = [
    ../../../programs/yamllint
  ];
}
