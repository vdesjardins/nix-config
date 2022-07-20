{ pkgs, ... }:
{
  packages = with pkgs; [
    unstable.stylua
    unstable.selene
    unstable.sumneko-lua-language-server
  ];
}
