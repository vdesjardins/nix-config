{
  config,
  lib,
  my-packages,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.playwright;
in {
  options.modules.ai.mcp.playwright = {
    enable = mkEnableOption "playwright mcp server";

    package = mkPackageOption my-packages "playwright-mcp" {};

    executable = lib.mkOption {
      type = lib.types.path;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin
        then lib.getExe pkgs.google-chrome
        else lib.getExe pkgs.chromium;
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.playwright = {
        command = getExe cfg.package;
        args = [
          "--executable-path"
          cfg.executable
        ];
      };

      ai.agents.github-copilot-cli.settings.mcpServers.playwright = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [
          "--executable-path"
          cfg.executable
        ];
      };
    };

    programs.opencode.settings.mcp.playwright = {
      enabled = false;
      type = "local";
      command = [
        (getExe cfg.package)
        "--executable-path"
        cfg.executable
      ];
    };
  };
}
