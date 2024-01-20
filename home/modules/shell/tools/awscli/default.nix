{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.awscli2;
in {
  options.modules.shell.tools.awscli2 = {
    enable = mkEnableOption "awscli2";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [aws-iam-authenticator unstable.awscli2 aws-sso-creds];

    home.file.".aws/cli/alias".source = ./alias;
    programs.zsh = {
      initExtra = ''
        complete -C ${pkgs.awscli2}/bin/aws_completer aws

        function aws-profile-name-from-id() {
          aws_account_id=$1
          jc --ini <~/.aws/config | jq 'to_entries | .[] | select(.value.sso_account_id == "'"$aws_account_id"'") | .key | split("\\s+"; "")[1]' -Mr
        }
        function aws-profile-id-from-name() {
          aws_account_name=$1
          jc --ini <~/.aws/config | jq '[ to_entries | .[] | select((.key | split("(\\.|\\s+)"; "")[1]) == "'"$aws_account_name"'") | .value.sso_account_id ] | unique | .[]' -Mr
        }

      '';
      envExtra = ''
        export AWS_PAGER=""
      '';

      shellAliases = {
        aws-creds = "eval $(aws configure export-credentials --format env)";
        ap = "aws-profile";
        al = "aws sso login --profile login";
      };
    };

    xdg.configFile."zsh/functions/aws-profile".source =
      ./zsh/functions/aws-profile;
  };
}
