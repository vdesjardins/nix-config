{pkgs, ...}: {
  packages = with pkgs; [
    gopls
  ];
}
