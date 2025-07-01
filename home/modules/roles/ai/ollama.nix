{
  config,
  pkgs,
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
        enable = false;
        acceleration = "rocm"; # "rocm" or "cuda"
        package = pkgs.ollama;
      };
      description = ''
        Configuration for the Ollama service, which provides a server for local large language models.
      '';
    };
  };

  config = mkIf cfg.enable {
    modules.services.ollama = cfg.settings;

    # needed until support is added for gfx1103
    home.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "gfx1102";
  };
}
