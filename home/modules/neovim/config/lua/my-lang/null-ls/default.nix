{pkgs, ...}: {
  packages = with pkgs; [
    vale # syntax-aware linter for prose
    nodePackages.markdownlint-cli
  ];
}
