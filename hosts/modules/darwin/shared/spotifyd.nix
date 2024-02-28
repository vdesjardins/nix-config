{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.services.spotifyd;
in {
  options.modules.services.spotifyd = {
    enable = mkEnableOption "spotifyd";

    deviceName = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    services.spotifyd = {
      enable = true;
      settings = {
        inherit (cfg) deviceName;

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
  };
}
