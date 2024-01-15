{device_name, ...}: {
  services.spotifyd = {
    enable = true;
    settings = {
      inherit device_name;

      username = "vdesjardins";

      use_keyring = true;

      device_type = "computer";

      no_audio_cache = false;

      bitrate = 320;
      volume_normalisation = true;
      normalisation_pregain = -10;

      volume_controller = "softvol";
    };
  };
}
