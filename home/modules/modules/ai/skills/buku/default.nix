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
