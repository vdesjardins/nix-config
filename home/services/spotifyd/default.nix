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
        password_cmd = "passage services/spotify";
        device = "pipewire";
        device_type = "computer";
      };
    };
  };
}
