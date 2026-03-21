{
  config,
  inputs,
  lib,
  my-packages,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkPackageOption;

  cfg = config.modules.ai.skills.agent-browser;
in {
  options.modules.ai.skills.agent-browser = {
    enable = mkEnableOption "agent-browser skill";
    package = mkPackageOption my-packages "skill-agent-browser" {};
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/agent-browser"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/agent-browser"
      ];
    };

    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser];

    home.file = {
      ".kiro/skills/agent-browser".source = "${cfg.package}/skills/agent-browser";
      ".copilot/skills/agent-browser".source = "${cfg.package}/skills/agent-browser";
    };

    xdg.configFile = {
      "opencode/skill/agent-browser".source = "${cfg.package}/skills/agent-browser";
    };
  };
}
