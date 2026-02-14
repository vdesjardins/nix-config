{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.sandbox-runtime;
in {
  options.modules.ai.tools.sandbox-runtime = {
    enable = mkEnableOption "sandbox-runtime for AI agent execution environments";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.sandbox-runtime
    ];
  };
}
