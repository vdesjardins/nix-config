{ pkgs, ... }: {
  home.packages = with pkgs; [ istioctl ];

  programs.zsh.shellAliases = {
    i = "istioctl";
    ie = "istioctl proxy-config endpoints";
    iej = "istioctl proxy-config endpoints -ojson";
    ic = "istioctl proxy-config clusters";
    icj = "istioctl proxy-config culsters -ojson";
    il = "istioctl proxy-config listeners";
    ilj = "istioctl proxy-config listeners -ojson";
    is = "istioctl proxy-status";
    itls = "istioctl authn tls-check";
    iaz = "istioctl x authz";
    idesc = "istioctl x describe";
  };
}
