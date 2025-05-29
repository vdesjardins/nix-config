{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.nix;
in {
  options.roles.dev.nix = {
    enable = mkEnableOption "dev.nix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixpkgs-fmt
      # nix-linter
      nix-bisect # bisect nix builds
      nix-init # generate nix packages
      nix-inspect # tui for evaluating nix expression
      nix-tree
      nix-prefetch
      nix-output-monitor
      nurl # generate nix fetcher calls
      nvd # package version diff tool
    ];
  };
}
