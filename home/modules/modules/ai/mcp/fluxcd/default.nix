{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.fluxcd;
in {
  options.modules.ai.mcp.fluxcd = {
    enable = mkEnableOption "fluxcd mcp server";

    package = mkPackageOption pkgs "fluxcd-operator-mcp" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.fluxcd = {
        command = getExe cfg.package;
        args = ["serve"];
        env = {
          KUBECONFIG = "";
        };
      };

      ai.agents = {
        antigravity.mcpServers.fluxcd = {
          command = getExe cfg.package;
          args = ["serve"];
          disabled = true;
          # Credentials and other session variables are inherited at runtime.
        };

        codex.mcpServers.fluxcd = {
          command = getExe cfg.package;
          args = ["serve"];
          enabled = false;
          env_vars = ["KUBECONFIG"];
        };

        claude-code.mcpServers.fluxcd = {
          type = "stdio";
          command = getExe cfg.package;
          args = ["serve"];
          enabled = false;
        };

        github-copilot-cli.settings.mcpServers.fluxcd = {
          type = "local";
          command = getExe cfg.package;
          tools = ["*"];
          args = ["serve"];
          environment = {
            KUBECONFIG = "";
          };
        };

        kiro.settings.mcpServers.fluxcd = {
          command = getExe cfg.package;
          args = ["serve"];
          env = {
            KUBECONFIG = "";
          };
          disabled = true;
        };
      };
    };

    programs.opencode.settings.mcp.fluxcd = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package) "serve"];
      environment = {
        KUBECONFIG = "{env:KUBECONFIG}";
      };
    };
  };
}
