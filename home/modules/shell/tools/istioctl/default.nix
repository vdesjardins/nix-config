{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.istioctl;
in {
  options.modules.shell.tools.istioctl = {
    enable = mkEnableOption "istioctl";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [istioctl];

    programs.zsh.shellAliases = {
      i = "istioctl";
      ie = "istioctl proxy-config endpoints";
      iej = "istioctl proxy-config endpoints -ojson";
      ic = "istioctl proxy-config clusters";
      icj = "istioctl proxy-config clusters -ojson";
      il = "istioctl proxy-config listeners";
      ilj = "istioctl proxy-config listeners -ojson";
      is = "istioctl proxy-status";
      itls = "istioctl authn tls-check";
      iaz = "istioctl x authz";
      idesc = "istioctl x describe";
    };
  };
}
