{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  programs.imv = {
    settings = {
      options = {
        background = "24283b";
        fullscreen = "true";
        overlay = "false";
      };
    };
  };
}
