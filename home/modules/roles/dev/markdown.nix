{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.markdown;
in {
  options.roles.dev.markdown = {
    enable = mkEnableOption "dev.markdown";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      glow # renders markdown on command line
      rumdl # markdown linter
    ];
  };
}
