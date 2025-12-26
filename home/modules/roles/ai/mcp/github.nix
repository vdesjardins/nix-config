{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.types) str;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.github;
in {
  options.roles.ai.mcp.github = {
    enable = mkEnableOption "github";

    personalAccessToken = lib.mkOption {
      type = str;
      default = "$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default 2>/dev/null || echo 'not-set')";
      description = "GitHub Personal Access Token for GitHub MCP server";
    };
  };

  config = mkIf cfg.enable {
    modules.mcp.github = {
      enable = true;
      personalAccessToken = cfg.personalAccessToken;
    };
  };
}
