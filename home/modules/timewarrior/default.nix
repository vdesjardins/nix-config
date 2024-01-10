{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.timewarrior;
in {
  options.programs.timewarrior = {
    enable = mkEnableOption "timewarrior";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      timewarrior
    ];

    programs.zsh.shellAliases = {
      twt = "timew track";
      tws = "timew summary :week :ids";
      twta = "timew tags";
    };
  };
}
