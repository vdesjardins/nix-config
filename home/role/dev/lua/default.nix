{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lua5_3
    unstable.stylua
    lua53Packages.luacheck
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs;
    [ unstable.sumneko-lua-language-server ]);
}
