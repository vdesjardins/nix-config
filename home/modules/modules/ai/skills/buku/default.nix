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
    modules.ai.agents.kiro.settings.resources = [
      "skill://${config.home.homeDirectory}/.kiro/skills/buku"
    ];

    # Install buku package
    home.packages = [pkgs.buku];

    # Copy skill files for Kiro
    home.file.".kiro/skills/buku".source = ./skill;

    # Register skill with OpenCode
    programs.opencode = {
      skills.buku = ./skill;

      # Permissive bash permissions for all buku commands
      settings.permission.bash = {
        "buku *" = "allow";
      };
    };
  };
}
