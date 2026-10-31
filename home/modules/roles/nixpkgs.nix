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
        # Home Manager still requires GTK2 for its input-method cache.
        problems.handlers."gtk+".broken = "ignore";
        permittedInsecurePackages = [
          "electron-39.8.10"
        ];
      }
    '';
    nixpkgs.config = {
      allowUnfree = true;
      # Home Manager still requires GTK2 for its input-method cache.
      problems.handlers."gtk+".broken = "ignore";
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };
  };
}
