{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.skills.agent-browser;
in {
  options.modules.ai.skills.agent-browser = {
    enable = mkEnableOption "agent-browser skill";
  };

  config = mkIf cfg.enable {
    modules.ai.agents.kiro.settings.resources = [
      "skill://${config.home.homeDirectory}/.kiro/skills/agent-browser"
    ];

    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser];

    # Link skill files from the npm package
    home.file.".kiro/skills/agent-browser" = {
      source = "${inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser}/etc/agent-browser/skills/agent-browser";
      recursive = true;
    };

    xdg.configFile."opencode/skill/agent-browser" = {
      source = "${inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser}/etc/agent-browser/skills/agent-browser";
      recursive = true;
    };
  };
}
