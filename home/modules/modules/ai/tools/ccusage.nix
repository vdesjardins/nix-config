{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.ccusage;
in {
  options.modules.ai.tools.ccusage = {
    enable = mkEnableOption "ccusage - analyze coding agent CLI token usage and costs";

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccusage;
      description = "The ccusage package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
