{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.github;
in {
  options.modules.ai.mcp.github = {
    enable = mkEnableOption "github mcp server";

    package = mkPackageOption my-packages "github-mcp-server" {};

    personalAccessToken = lib.mkOption {
      type = lib.types.str;
      default = "$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default 2>/dev/null || echo 'not-set')";
      description = "GitHub Personal Access Token for GitHub MCP server";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.github = {
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

      ai.agents = {
        antigravity.mcpServers.github = {
          command = getExe cfg.package;
          args = ["stdio"];
          disabled = true;
          # Credentials and other session variables are inherited at runtime.
        };

        codex.mcpServers.github = {
          command = getExe cfg.package;
          args = ["stdio"];
          enabled = false;
          env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN"];
        };

        claude-code.mcpServers.github = {
          type = "stdio";
          command = getExe cfg.package;
          args = ["stdio"];
          enabled = false;
        };

        kiro.settings.mcpServers.github = {
          command = getExe cfg.package;
          args = ["stdio"];
          env = {
            GITHUB_PERSONAL_ACCESS_TOKEN = "";
          };
        };

        pi.mcpServers.github = {
          command = getExe cfg.package;
          args = ["stdio"];
          enabled = false;
        };
      };
    };

    programs = {
      opencode.settings.mcp.github = {
        enabled = false;
        type = "local";
        command = [(getExe cfg.package) "stdio"];
      };

      zsh.initContent = ''
        mkdir -p ~/.local/share/github-cmp-server/
      '';
    };
    home.sessionVariables.GITHUB_PERSONAL_ACCESS_TOKEN = cfg.personalAccessToken;
  };
}
