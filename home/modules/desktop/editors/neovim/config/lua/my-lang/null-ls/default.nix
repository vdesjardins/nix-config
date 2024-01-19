{pkgs, ...}: {
  packages = with pkgs; [
    nodePackages.markdownlint-cli
  ];
}
