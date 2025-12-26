{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.github;
in {
  options.modules.mcp.github = {
    enable = mkEnableOption "github mcp server";

    package = mkPackageOption my-packages "github-mcp-server" {};

    personalAccessToken = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default 2>/dev/null || echo 'not-set')";
      description = "GitHub Personal Access Token for GitHub MCP server";
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.github = {
      command = getExe cfg.package;
      args = [
        "stdio"
        # "--enable-command-logging"
        # "--log-file=${config.home.homeDirectory}/.local/share/github-cmp-server/command.log"
      ];
      env = {
        # passthrough GITHUB_PERSONAL_ACCESS_TOKEN from passage
        GITHUB_PERSONAL_ACCESS_TOKEN = "";
      };
    };

    modules.mcp.utcp-code-mode = {
      mcpServers.github = {
        transport = "stdio";
        command = getExe cfg.package;
        args = [
          "stdio"
        ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_PERSONAL_ACCESS_TOKEN}";
        };
      };
      sessionVariables.GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_PERSONAL_ACCESS_TOKEN}";
    };

    programs = {
      opencode.settings.mcp.github = {
        enabled = false;
        type = "local";
        command = [(getExe cfg.package) "stdio"];
      };

      codex.settings.mcp_servers.github = {
        enabled = false;
        command = getExe cfg.package;
        args = ["stdio"];
        env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN"];
      };

      zsh.initContent = ''
        mkdir -p ~/.local/share/github-cmp-server/
      '';
    };
    home.sessionVariables.GITHUB_PERSONAL_ACCESS_TOKEN = cfg.personalAccessToken;
  };
}
