{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.tuicr;
in {
  options.modules.shell.tools.tuicr = {
    enable = mkEnableOption "tuicr - Terminal UI for code review and collaboration";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr];
  };
}
