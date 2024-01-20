{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.ripgrep;
in {
  options.modules.shell.tools.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      inherit (cfg) enable;

      arguments = [
        "--max-columns=150"
        "--max-columns-preview"
        "--hidden"
        "--type-add=zshrc:*.zsh*"
        "--type-add=bashrc:*.sh*"
        "--type-add=automake:*makefile.in*"
        "--glob=!git/*"
        "--glob=!.git/*"
        "--ignore-case"
      ];
    };
  };
}
