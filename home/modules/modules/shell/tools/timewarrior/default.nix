{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.timewarrior;
in {
  options.modules.shell.tools.timewarrior = {
    enable = mkEnableOption "timewarrior";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      timewarrior
    ];

    programs.zsh.shellAliases = {
      tw = "timew";
      twt = "timew track";
      tws = "timew summary :week :ids";
      twta = "timew tags";
    };
  };
}
