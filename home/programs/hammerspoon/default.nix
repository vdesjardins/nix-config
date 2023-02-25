{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".hammerspoon/Spoons/ControlEscape.spoon/".source = "${pkgs.hammerspoon-controlescape}/share/hammerspoon/controlescape/";
  home.file.".hammerspoon/init.lua".source = ./init.lua;
}
