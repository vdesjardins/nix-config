{pkgs, ...}: {
  packages = with pkgs; [
    unstable.pyright
    unstable.ruff
  ];
}
