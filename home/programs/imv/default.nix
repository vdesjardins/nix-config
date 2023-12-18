{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "24283b";
        fullscreen = "true";
        overlay = "false";
      };
    };
  };
}
