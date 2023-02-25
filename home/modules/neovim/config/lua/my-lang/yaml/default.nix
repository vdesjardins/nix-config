{pkgs, ...}: {
  packages = with pkgs; [
    yamllint
    nodePackages.yaml-language-server
  ];
}
