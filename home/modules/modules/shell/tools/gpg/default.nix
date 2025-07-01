{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.gpg;
in {
  options.modules.shell.tools.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      # ref: https://github.com/NixOS/nixpkgs/issues/155629
      scdaemonSettings =
        if pkgs.hostPlatform.isDarwin
        then {
          disable-ccid = true;
        }
        else {};

      publicKeys = [
        {
          source = ./pubkeys.txt;
        }
      ];
    };
  };
}
