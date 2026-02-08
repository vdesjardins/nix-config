{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools."coding-agent-search";
in {
  options.modules.ai.tools."coding-agent-search" = {
    enable = mkEnableOption "coding-agent-search - code search tool for LLM agents";

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent-search;
      description = "The coding-agent-search package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
