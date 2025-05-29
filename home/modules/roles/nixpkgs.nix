{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.nixpkgs;
in {
  options.roles.nixpkgs = {
    enable = mkEnableOption "nixpkgs";
  };

  config = mkIf cfg.enable {
    xdg.configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        allowBroken = true;
      }
    '';
    nixpkgs.config.allowUnfree = true;
  };
}
