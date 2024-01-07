{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.any-nix-shell;
in {
  options.programs.any-nix-shell = {
    enable = mkEnableOption "any-nix-shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [any-nix-shell];

    programs.zsh.initExtra = ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
