{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.grafana;
in {
  options.roles.ai.mcp.grafana = {
    enable = mkEnableOption "grafana";

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
    modules.mcp.grafana = {
      enable = true;
      grafanaUrl = cfg.grafanaUrl;
    };
  };
}
