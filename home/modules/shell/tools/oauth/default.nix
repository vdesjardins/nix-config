{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.oauth;
in {
  options.modules.shell.tools.oauth = {
    enable = mkEnableOption "oauth";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      oauth2c
    ];

    programs.zsh.initExtra =
      # bash
      ''
        jwt-decode() {
          jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
        }
      '';
  };
}
