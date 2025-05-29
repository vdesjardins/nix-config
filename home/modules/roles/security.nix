{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.security;
in {
  options.roles.security = {
    enable = mkEnableOption "security";
  };

  config = mkIf cfg.enable {
    modules.shell.tools = {
      ssh.enable = true;
      gpg.enable = true;
      gpg-agent.enable = true;
      oauth.enable = true;
    };

    home.packages = with pkgs; [
      gopass
      minisign
      yubikey-manager
    ];
  };
}
