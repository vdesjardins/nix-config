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
    home = {
      packages = with pkgs; [aws-iam-authenticator awscli2 aws-sso-creds];
      file.".aws/cli/alias".source = ./alias;
      sessionVariables = {
        AWS_PAGER = "";
      };
    };

    programs.zsh = {
      initContent = ''
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

      shellAliases = {
        aws-creds = "eval $(aws configure export-credentials --format env)";
        ap = "aws-profile";
        al = "aws sso login --profile login";
      };
    };

    programs.nushell = {
      shellAliases = {
        ap = "aws-profile";
        al = "aws sso login --profile login";
      };
      extraConfig = ''

        # Export AWS credentials as environment variables
        def aws-creds [] {
          aws configure export-credentials --format env | lines | each { |line|
            let parts = ($line | split row '=')
            if ($parts | length) == 2 {
              load-env {($parts.0): ($parts.1)}
            }
          }
        }

        # Set AWS profile, optionally using fzf to select from available profiles
        def aws-profile [profile?: string] {
          # Unset AWS credentials
          hide-env AWS_ACCESS_KEY_ID
          hide-env AWS_SECRET_ACCESS_KEY
          hide-env AWS_SESSION_TOKEN

          if ($profile != null) {
            $env.AWS_PROFILE = $profile
          } else {
            # Use fzf to select profile from ~/.aws/config
            let selected = (
              jc --ini < ~/.aws/config
              | from json
              | transpose key value
              | where value.sso_account_id? != null
              | each { |row|
                  let profile_name = ($row.key | split row ' ' | last)
                  $"($row.value.sso_account_id)\t($profile_name)"
                }
              | str join (char newline)
              | fzf
              | split row "\t"
              | last
            )
            $env.AWS_PROFILE = $selected
          }
        }

        # Get AWS profile name from account ID
        def aws-profile-name-from-id [aws_account_id: string] {
          jc --ini < ~/.aws/config
          | from json
          | transpose key value
          | where value.sso_account_id? == $aws_account_id
          | get key
          | first
          | split row ' '
          | last
        }

        # Get AWS account ID from profile name
        def aws-profile-id-from-name [aws_account_name: string] {
          jc --ini < ~/.aws/config
          | from json
          | transpose key value
          | where ($it.key | split row ' ' | last) == $aws_account_name
          | get value.sso_account_id
          | uniq
        }
      '';
    };

    xdg.configFile."zsh/functions/aws-profile".source =
      ./zsh/functions/aws-profile;
  };
}
