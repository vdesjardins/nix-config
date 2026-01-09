{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.fluxcd;
in {
  options.modules.mcp.fluxcd = {
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

      mcp.utcp-code-mode = {
        mcpServers.fluxcd = {
          transport = "stdio";
          command = getExe cfg.package;
          args = [
            "serve"
          ];
          env = {
            KUBECONFIG = "\${KUBECONFIG}";
          };
        };
        sessionVariables.KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
      };

      shell.tools.github-copilot-cli.settings.mcpServers.fluxcd = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = ["serve"];
        environment = {
          KUBECONFIG = "";
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
