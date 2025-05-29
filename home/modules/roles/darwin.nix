{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.darwin;
in {
  options.roles.darwin = {
    enable = mkEnableOption "darwin";
  };

  config = mkIf cfg.enable {
    modules.darwin.app-symlinks.enable = true;

    programs.zsh.shellGlobalAliases = {
      CL = "|& pbcopy";
    };
  };
}
