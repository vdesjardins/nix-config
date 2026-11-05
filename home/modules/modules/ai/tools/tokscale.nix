{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.tokscale;
in {
  options.modules.ai.tools.tokscale = {
    enable = mkEnableOption "tokscale - track coding agent token usage and costs";

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tokscale;
      description = "The tokscale package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
