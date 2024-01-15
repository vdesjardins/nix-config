{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf package;
in {
  options.fonts.packages = mkOption {
    type = listOf package;
  };

  config.fonts.fonts = config.fonts.packages;
}
