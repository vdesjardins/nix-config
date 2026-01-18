{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe;

  cfg = config.modules.mcp.tmux-mcp;
in {
  options.modules.mcp.tmux-mcp = {
    enable = mkEnableOption "tmux-mcp MCP server";

    package = mkPackageOption my-packages "tmux-mcp" {};

    shellType = mkOption {
      type = types.str;
      default = "zsh";
      description = "Shell type to use with tmux-mcp";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.tmux-mcp = {
        command = getExe cfg.package;
        args = [
          "--shell-type"
          cfg.shellType
        ];
      };

      mcp.utcp-code-mode.mcpServers.tmux-mcp = {
        transport = "stdio";
        command = getExe cfg.package;
        args = [
          "--shell-type"
          cfg.shellType
        ];
      };

      shell.tools.github-copilot-cli.settings.mcpServers.tmux-mcp = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [
          "--shell-type"
          cfg.shellType
        ];
      };
    };

    programs.opencode.settings.mcp.tmux-mcp = {
      enabled = false;
      type = "local";
      command = [
        (getExe cfg.package)
        "--shell-type"
        cfg.shellType
      ];
    };
  };
}
