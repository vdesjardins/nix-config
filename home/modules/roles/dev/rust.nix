{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.rust;
in {
  options.roles.dev.rust = {
    enable = mkEnableOption "dev.rust";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [crate2nix rust-bin.stable.latest.default];
  };
}
