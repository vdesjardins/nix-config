{
  config,
  lib,
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
        acceleration = "rocm"; # "rocm" or "cuda"
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
