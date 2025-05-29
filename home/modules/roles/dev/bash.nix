{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.bash;
in {
  options.roles.dev.bash = {
    enable = mkEnableOption "dev.bash";
  };

  config = mkIf cfg.enable {
    programs.bash.enable = true;

    home.packages = with pkgs; [
      bats
    ];
  };
}
