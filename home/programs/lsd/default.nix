{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [unstable.lsd];

  programs.zsh.shellAliases = {
    ls = "lsd";
    l = "lsd";
    ll = "lsd -ltr";
    la = "lsd -ltra";
  };
}
