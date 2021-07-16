{ pkgs, ... }: {
  home.packages = with pkgs; [ stern ];

  programs.zsh.initExtra = ''
    source <(${pkgs.stern}/bin/stern --completion zsh) 2>/dev/null
  '';
}
