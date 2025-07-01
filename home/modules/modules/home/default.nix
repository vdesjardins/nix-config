{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) path;
in {
  options.modules.home.configDirectory = mkOption {
    type = path;
    default = "${config.home.homeDirectory}/projects/nix-config/home/modules";
  };
}
