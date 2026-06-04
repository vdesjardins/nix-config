{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.exa;
in {
  options.modules.ai.mcp.exa = {
    enable = mkEnableOption "exa MCP server";

    package = mkPackageOption my-packages "exa-mcp-server" {};

    exaApiKey = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/exa/${config.home.username}/default 2>/dev/null || echo 'not-set')";
      description = "Exa API key (https://dashboard.exa.ai/api-keys)";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.exa = {
        command = getExe cfg.package;
        env = {
          EXA_API_KEY = "";
        };
      };

      ai.agents = {
        github-copilot-cli.settings.mcpServers.exa = {
          type = "local";
          command = getExe cfg.package;
          tools = ["*"];
          args = [];
          environment = {
            EXA_API_KEY = "";
          };
        };

        kiro.settings.mcpServers.exa = {
          command = getExe cfg.package;
          args = [];
          env = {
            EXA_API_KEY = "";
          };
          disabled = true;
        };
      };
    };

    programs.opencode.settings.mcp.exa = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
      environment = {
        EXA_API_KEY = "{env:EXA_API_KEY}";
      };
    };

    home.sessionVariables.EXA_API_KEY = cfg.exaApiKey;
  };
}
