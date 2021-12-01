{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # sumneko-lua-language-server
    lua5_3
    luaformatter
    lua53Packages.luacheck
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs;
    [ sumneko-lua-language-server ]);
}
