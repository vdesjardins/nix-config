{pkgs, ...}: {
  home.packages = with pkgs; [unstable.open-policy-agent];
}
