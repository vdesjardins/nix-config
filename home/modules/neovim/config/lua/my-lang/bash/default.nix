{ pkgs, ... }:
{
  packages = with pkgs; [
    shellcheck
    unstable.shellharden
    shfmt
    nodePackages.bash-language-server
  ];
}

