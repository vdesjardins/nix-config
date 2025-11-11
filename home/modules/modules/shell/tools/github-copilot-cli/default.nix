{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.github-copilot-cli;
in {
  options.modules.shell.tools.github-copilot-cli = {
    enable = mkEnableOption "github-copilot-cli";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.github-copilot-cli
    ];
  };
}
