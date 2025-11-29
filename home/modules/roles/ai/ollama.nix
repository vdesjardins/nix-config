{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.roles.ai.ollama;
in {
  options.roles.ai.ollama = {
    enable = mkEnableOption "ollama";

    settings = mkOption {
      type = lib.types.attrs;
      default = {
        enable = true;
        # TODO: not yet supported by home-manager module
        # acceleration = "vulkan";
        package = pkgs.ollama-vulkan;
      };
      description = ''
        Configuration for the Ollama service, which provides a server for local large language models.
      '';
    };
  };

  config = mkIf cfg.enable {
    modules.services.ollama = cfg.settings;
  };
}
