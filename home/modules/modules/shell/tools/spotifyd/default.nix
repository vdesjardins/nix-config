{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.spotifyd;
in {
  options.modules.shell.tools.spotifyd = {
    enable = mkEnableOption "spotifyd";
  };

  config = mkIf cfg.enable {
    services.spotifyd = {
      inherit (cfg) enable;

      settings = {
        global = {
          username = "vdesjardins";
          password_cmd = "passage services/spotify";
          device = "pipewire";
          device_type = "computer";
        };
      };
    };
  };
}
