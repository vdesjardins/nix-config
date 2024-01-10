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

    home.file.".kube/kubie.yaml".source =
      ./kubie.yaml;

    programs.zsh.shellAliases = {
      kbn = "kubie ns";
      kbx = "kubie ctx";
      kbe = "kubie exec";
    };
  };
}
