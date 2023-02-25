{pkgs, ...}: {
  home.packages = with pkgs; [any-nix-shell];

  programs.zsh.initExtra = ''
    any-nix-shell zsh --info-right | source /dev/stdin
  '';
}
