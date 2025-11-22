{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.try;
in {
  options.modules.shell.tools.try = {
    enable = mkEnableOption "try";
  };

  config = mkIf cfg.enable {
    programs.try = {
      enable = true;
      path = "~/projects/experiments";
    };

    # modules do not force a ruby runtime in zsh function wrapper, so we add it
    # here
    home.packages = with pkgs; [ruby];
  };
}
