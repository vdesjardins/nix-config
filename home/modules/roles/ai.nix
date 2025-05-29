{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai;
in {
  options.roles.ai = {
    enable = mkEnableOption "ai";
  };

  config = mkIf cfg.enable {
    modules.services.ollama = {
      enable = true;
      acceleration = "rocm";
      package = pkgs.ollama;
    };

    # needed until support is added for gfx1103
    home.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "gfx1102";
  };
}
