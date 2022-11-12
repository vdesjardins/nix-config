{ config, lib, pkgs, ... }:
{
  home.file.".hammerspoon/Spoons/ControlEscape.spoon/".source = "${pkgs.hammerspoon-controlescape}/share/hammerspoon/controlescape/";
  xdg.configFile.".hammerspoon/init.lua".source = ./init.lua;
}
