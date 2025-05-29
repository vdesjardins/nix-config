{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.bpf;
in {
  options.roles.ops.bpf = {
    enable = mkEnableOption "ops.bpf";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [bcc bpftools linuxPackages.bpftrace];
  };
}
