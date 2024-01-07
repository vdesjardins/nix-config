{pkgs, ...}: {
  # TODO: not working on aarch64
  programs.nix-index.enable = true;

  programs.nvim.lang.nix = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
    # nix-linter
    nix-tree
    nix-prefetch
    nix-output-monitor
    nvd # package version diff tool
  ];
}
