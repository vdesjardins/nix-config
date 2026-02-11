{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.modules.ai.mcp.mcporter;
in {
  options.modules.ai.mcp.mcporter = {
    enable = mkEnableOption "mcporter - TypeScript runtime and CLI for MCP servers";
    package = mkPackageOption my-packages "mcporter" {};
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # Add shell integration for mcporter command
    programs.zsh.shellAliases.mcporter = getExe cfg.package;
  };
}
