{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.container;
in {
  options.roles.ops.container = {
    enable = mkEnableOption "ops.container";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        buildkit
        dive
        docker
        grype # vulnerability scanner
        podman
        skopeo
        colima
        # unstable.colima
        lazydocker
      ]
      ++ lib.optionals stdenv.isLinux [
        cntr # container debugging tool
        nerdctl # docker compatible containerd cli
      ];
  };
}
