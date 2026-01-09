{
  config,
  lib,
  my-packages,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.grafana;
in {
  options.modules.mcp.grafana = {
    enable = mkEnableOption "grafana mcp server";

    package = mkPackageOption my-packages "mcp-grafana" {};

    grafanaUrl = lib.mkOption {
      type = lib.types.str;
      description = "Grafana URL for Grafana MCP server";
    };
    grafanaServiceAccountToken = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/grafana/${config.home.username}/token 2>/dev/null || echo 'not-set')";
      description = "Grafana Service Account Token for Grafana MCP server";
    };
    grafanaUsername = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/grafana/${config.home.username}/username 2>/dev/null || echo 'not-set')";
      description = "Grafana Username for Grafana MCP server";
    };
    grafanaPassword = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/grafana/${config.home.username}/password 2>/dev/null || echo 'not-set')";
      description = "Grafana Password for Grafana MCP server";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.grafana = {
        command = getExe cfg.package;
        env = {
          GRAFANA_URL = "";
          GRAFANA_SERVICE_ACCOUNT_TOKEN = "";
          GRAFANA_USERNAME = "";
          GRAFANA_PASSWORD = "";
        };
      };

      mcp.utcp-code-mode = {
        mcpServers.grafana = {
          transport = "stdio";
          command = getExe cfg.package;
          env = {
            GRAFANA_URL = "\${GRAFANA_URL}";
            GRAFANA_SERVICE_ACCOUNT_TOKEN = "\${GRAFANA_SERVICE_ACCOUNT_TOKEN}";
            GRAFANA_USERNAME = "\${GRAFANA_USERNAME}";
            GRAFANA_PASSWORD = "\${GRAFANA_PASSWORD}";
          };
        };
        sessionVariables = {
          GRAFANA_URL = "\${GRAFANA_URL}";
          GRAFANA_SERVICE_ACCOUNT_TOKEN = "\${GRAFANA_SERVICE_ACCOUNT_TOKEN}";
          GRAFANA_USERNAME = "\${GRAFANA_USERNAME}";
          GRAFANA_PASSWORD = "\${GRAFANA_PASSWORD}";
        };
      };

      shell.tools.github-copilot-cli.settings.mcpServers.grafana = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
        environment = {
          GRAFANA_URL = "";
          GRAFANA_SERVICE_ACCOUNT_TOKEN = "";
          GRAFANA_USERNAME = "";
          GRAFANA_PASSWORD = "";
        };
      };
    };

    programs.opencode.settings.mcp.grafana = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
      environment = {
        GRAFANA_URL = "{env:GRAFANA_URL}";
        GRAFANA_SERVICE_ACCOUNT_TOKEN = "{env:GRAFANA_SERVICE_ACCOUNT_TOKEN}";
        GRAFANA_USERNAME = "{env:GRAFANA_USERNAME}";
        GRAFANA_PASSWORD = "{env:GRAFANA_PASSWORD}";
      };
    };

    home.sessionVariables = {
      GRAFANA_URL = cfg.grafanaUrl;
      GRAFANA_SERVICE_ACCOUNT_TOKEN = cfg.grafanaServiceAccountToken;
      GRAFANA_USERNAME = cfg.grafanaUsername;
      GRAFANA_PASSWORD = cfg.grafanaPassword;
    };
  };
}
