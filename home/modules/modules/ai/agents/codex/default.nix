{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ai.agents.codex;
  toml = pkgs.formats.toml {};
  python = pkgs.python3.withPackages (ps: [ps.tomlkit]);
  nixConfig = toml.generate "codex-nix-config.toml" (
    lib.recursiveUpdate cfg.settings {mcp_servers = cfg.mcpServers;}
  );
in {
  options.modules.ai.agents.codex = {
    enable = lib.mkEnableOption "Codex CLI AI agent";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
      description = "Codex package from the pinned llm-agents input.";
    };
    settings = lib.mkOption {
      inherit (toml) type;
      default = {};
      description = "Nix-managed Codex settings; authentication remains unmanaged.";
    };
    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = "Native Codex MCP definitions contributed by each owning MCP module.";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [cfg.package];
      file.".codex/nix-config.toml".source = nixConfig;
      # Run before old Home Manager links are cleaned up so migration preserves
      # any existing config, atomically replacing its store symlink if necessary.
      activation.codexSettings = lib.hm.dag.entryBetween ["linkGeneration"] ["writeBoundary"] ''
        if [ -z "''${DRY_RUN_CMD:-}" ]; then
          ${lib.getExe python} ${./merge-config.py} ${lib.escapeShellArgs [
          (toString nixConfig)
          "${config.home.homeDirectory}/.codex/config.toml"
          "${config.home.homeDirectory}/.codex/nix-managed.json"
        ]}
        fi
      '';
    };
  };
}
