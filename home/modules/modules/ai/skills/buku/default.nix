{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.skills.buku;
in {
  options.modules.ai.skills.buku = {
    enable = mkEnableOption "buku bookmark manager skill";
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/buku"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/buku"
      ];
    };

    # Install buku package
    home.packages = [pkgs.buku];

    # Copy skill files for Kiro and Copilot CLI
    home.file = {
      ".kiro/skills/buku".source = ./skill;
      ".copilot/skills/buku".source = ./skill;
    };

    # Register skill with OpenCode and Copilot CLI
    programs.opencode = {
      skills.buku = ./skill;

      # Permissive bash permissions for all buku commands
      settings.permission.bash = {
        "buku *" = "allow";
      };
    };

    xdg.configFile.".copilot/skills/buku" = {
      source = ./skill;
      recursive = true;
    };
  };
}
