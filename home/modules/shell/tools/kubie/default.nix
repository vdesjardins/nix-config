{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.kubie;
in {
  options.modules.shell.tools.kubie = {
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
