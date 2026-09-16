{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.mcp.mcporter;
in {
  options.modules.ai.mcp.mcporter = {
    enable = mkEnableOption "mcporter - TypeScript runtime and CLI for MCP servers";
    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.mcporter;
      description = "The mcporter package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # Add shell integration for mcporter command
    programs.zsh.shellAliases.mcporter = getExe cfg.package;
    modules.shell.nushell.globalAliases.mcporter = getExe cfg.package;
  };
}
