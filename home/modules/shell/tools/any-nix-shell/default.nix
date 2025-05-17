{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.any-nix-shell;
in {
  options.modules.shell.tools.any-nix-shell = {
    enable = mkEnableOption "any-nix-shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [any-nix-shell];

    programs.zsh.initContent = ''
      any-nix-shell zsh | source /dev/stdin
    '';
  };
}
