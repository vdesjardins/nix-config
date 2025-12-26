{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.extensions.dconf;
in {
  options.modules.desktop.extensions.dconf = {
    enable = mkEnableOption "dconf";

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    dconf = {
      inherit (cfg) enable;
    };
  };
}
