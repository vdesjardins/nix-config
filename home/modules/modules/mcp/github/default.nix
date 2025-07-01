{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.github;
in {
  options.modules.mcp.github = {
    enable = mkEnableOption "github mcp server";

    package = mkPackageOption pkgs "github-mcp-server" {};
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

    programs.zsh.initContent = ''
      mkdir -p ~/.local/share/github-cmp-server/
      export GITHUB_PERSONAL_ACCESS_TOKEN="$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default 2>/dev/null || echo 'not-set')"
    '';
  };
}
