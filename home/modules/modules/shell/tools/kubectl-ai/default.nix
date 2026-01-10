{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  yamlFormat = pkgs.formats.yaml {};

  cfg = config.modules.shell.tools.kubectl-ai;
in {
  options.modules.shell.tools.kubectl-ai = {
    enable = mkEnableOption "kubectl-ai";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [kubectl-ai];
  };
}
