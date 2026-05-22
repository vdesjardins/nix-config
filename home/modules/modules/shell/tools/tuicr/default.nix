{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.tuicr;

  # Fetch tuicr skill from GitHub
  tuicrSkill = pkgs.fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    rev = "35ecbe2863d7a0a5321612bf6bb955006fab24c2";
    hash = "sha256-WkPMecljTG/cEg2+AAgCk92ta8Gs2UhY32n2u6h7eU0=";
  };
in {
  options.modules.shell.tools.tuicr = {
    enable = mkEnableOption "tuicr - Terminal UI for code review and collaboration";
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/tuicr"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/tuicr"
      ];
    };

    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr];

    home.file = {
      ".kiro/skills/tuicr" = {
        source = "${tuicrSkill}/skills/tuicr";
        recursive = true;
      };

      ".copilot/skills/tuicr" = {
        source = "${tuicrSkill}/skills/tuicr";
        recursive = true;
      };

      ".pi/agent/skills/tuicr" = {
        source = "${tuicrSkill}/skills/tuicr";
        recursive = true;
      };
    };

    xdg.configFile = {
      "opencode/skill/tuicr" = {
        source = "${tuicrSkill}/skills/tuicr";
        recursive = true;
      };

      ".copilot/skills/tuicr" = {
        source = "${tuicrSkill}/skills/tuicr";
        recursive = true;
      };
    };
  };
}
