{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.jwt;
in {
  options.modules.shell.tools.jwt = {
    enable = mkEnableOption "jwt";
  };

  config = mkIf cfg.enable {
    programs.zsh.initExtra =
      # bash
      ''
        jwt-decode() {
          jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
        }
      '';
  };
}
