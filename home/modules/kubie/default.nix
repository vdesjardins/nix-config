{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.kubie;
in {
  options.programs.kubie = {
    enable = mkEnableOption "kubie";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [kubie];

    programs.zsh.shellAliases = {
      kbn = "kubie ns";
      kbc = "kubie ctx";
      kbe = "kubie exec";
    };
  };
}
