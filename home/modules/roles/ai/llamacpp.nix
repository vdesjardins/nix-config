{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.roles.ai.llamacpp;
in {
  options.roles.ai.llamacpp = {
    enable = mkEnableOption "llamacpp";

    settings = mkOption {
      type = lib.types.attrs;
      default = {
        enable = true;
        package = inputs.llamacpp.packages.${pkgs.system}.vulkan;
      };
      description = ''
        Configuration for the llamacpp service
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.settings.package];
  };
}
