{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.darwin.hammerspoon;
in {
  options.modules.darwin.hammerspoon = {
    enable = mkEnableOption "hammerspoon";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".hammerspoon/Spoons/ControlEscape.spoon/".source = "${pkgs.hammerspoon-controlescape}/share/hammerspoon/controlescape/";
      ".hammerspoon/Spoons/PushToTalk.spoon/".source = "${pkgs.hammerspoon-push-to-talk}/share/hammerspoon/PushToTalk.spoon/";
      ".hammerspoon/init.lua".source = ./init.lua;
    };
  };
}
