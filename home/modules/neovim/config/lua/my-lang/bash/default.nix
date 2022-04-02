{ pkgs, ... }:
{
  packages = with pkgs; [
    shellcheck
    shellharden
    shfmt
    nodePackages.bash-language-server
  ];
}

