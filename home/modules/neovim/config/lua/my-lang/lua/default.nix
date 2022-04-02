{ pkgs, ... }:
{
  packages = with pkgs; [
    unstable.stylua
    unstable.selene
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs;
    [ unstable.sumneko-lua-language-server ]);
}
