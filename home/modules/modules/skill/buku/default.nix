{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.skill.buku;
in {
  options.modules.skill.buku = {
    enable = mkEnableOption "buku bookmark manager skill";
  };

  config = mkIf cfg.enable {
    # Install buku package
    home.packages = [pkgs.buku];

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
