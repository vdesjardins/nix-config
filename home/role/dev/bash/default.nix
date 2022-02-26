{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bash
    bats
    shellcheck
    shellharden
    shfmt
    nodePackages.bash-language-server
  ];
}
