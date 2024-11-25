{pkgs, ...}: {
  packages = with pkgs; [
    pyright
    ruff
  ];
}
