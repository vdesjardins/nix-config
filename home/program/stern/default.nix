{ pkgs, ... }: {
  home.packages = with pkgs; [ unstable.stern ];

  programs.zsh.initExtra = ''
    source <(${pkgs.stern}/bin/stern --completion zsh)
  '';
}
