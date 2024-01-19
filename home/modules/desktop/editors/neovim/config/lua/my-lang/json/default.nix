{pkgs, ...}: {
  packages = with pkgs; [
    nodePackages.vscode-langservers-extracted
  ];
}
