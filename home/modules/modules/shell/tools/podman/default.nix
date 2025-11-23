{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.podman;
in {
  options.modules.shell.tools.podman = {
    enable = mkEnableOption "podman";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      podman
    ];

    programs.zsh.shellAliases = {
      p = "podman";
      pps = "podman ps";
      pimg = "podman images";
    };
  };
}
