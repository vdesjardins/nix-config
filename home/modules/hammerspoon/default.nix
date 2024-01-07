{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.hammerspoon;
in {
  options.programs.hammerspoon = {
    enable = mkEnableOption ".hammerspoon";
  };

  config = mkIf cfg.enable {
    home.file.".hammerspoon/Spoons/ControlEscape.spoon/".source = "${pkgs.hammerspoon-controlescape}/share/hammerspoon/controlescape/";
    home.file.".hammerspoon/Spoons/PushToTalk.spoon/".source = "${pkgs.hammerspoon-push-to-talk}/share/hammerspoon/PushToTalk.spoon/";
    home.file.".hammerspoon/init.lua".source = ./init.lua;
  };
}
