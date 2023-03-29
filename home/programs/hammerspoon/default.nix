{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".hammerspoon/Spoons/ControlEscape.spoon/".source = "${pkgs.hammerspoon-controlescape}/share/hammerspoon/controlescape/";
  home.file.".hammerspoon/Spoons/PushToTalk.spoon/".source = "${pkgs.hammerspoon-push-to-talk}/share/hammerspoon/PushToTalk.spoon/";
  home.file.".hammerspoon/init.lua".source = ./init.lua;
}
