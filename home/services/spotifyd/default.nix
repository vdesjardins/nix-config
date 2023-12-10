{
  config,
  lib,
  pkgs,
  ...
}: {
  services.spotifyd = {
    enable = true;

    settings = {
      global = {
        username = "vdesjardins";
        password_cmd = "passage spotify";
        device = "default:CARD=Generic";
        device_type = "computer";
      };
    };
  };
}
