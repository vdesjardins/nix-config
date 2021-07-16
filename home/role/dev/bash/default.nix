{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bash
    bats
    shellcheck
    shfmt
    nodePackages.bash-language-server
  ];
}
