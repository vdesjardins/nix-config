{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ai.agents.claude-code;
  json = pkgs.formats.json {};
in {
  options.modules.ai.agents.claude-code = {
    enable = lib.mkEnableOption "Claude Code with module-owned MCP and skills";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
      description = "Claude Code package from the pinned llm-agents input.";
    };
    settings = lib.mkOption {
      inherit (json) type;
      default = {};
      description = "Claude Code settings merged into its writable settings.json.";
    };
    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = "Native MCP definitions contributed by each owning feature module.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      inherit (cfg) package mcpServers;
      mutableSettings = true;
      # Supply an empty base so Home Manager recomputes the complete disabled
      # list even when the last disabled server is removed or enabled.
      settings = {disabledMcpjsonServers = [];} // cfg.settings;
    };
  };
}
