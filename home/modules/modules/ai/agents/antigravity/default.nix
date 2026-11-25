{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ai.agents.antigravity;
in {
  options.modules.ai.agents.antigravity = {
    enable = lib.mkEnableOption "Antigravity CLI AI agent";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli;
      description = "Antigravity CLI package from the pinned llm-agents input.";
    };
    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = ''
        Native Antigravity MCP definitions contributed by each enabled MCP
        module. This Nix-managed file is shared with other Antigravity products.
        Credentials should be inherited from the runtime environment, not
        embedded in Nix expressions.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    home.file.".gemini/config/mcp_config.json".text = builtins.toJSON {inherit (cfg) mcpServers;};
  };
}
