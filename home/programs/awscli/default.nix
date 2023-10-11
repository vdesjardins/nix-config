{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
  mkMerge [
    {
      home.packages = with pkgs; [aws-iam-authenticator awscli2];
      home.file.".aws/cli/alias".source = ./alias;
    }
    (
      mkIf config.programs.zsh.enable {
        programs.zsh = {
          initExtra = ''
            complete -C ${pkgs.awscli2}/bin/aws_completer aws

            function aws-find-profiles() {
              aws_account_id=$1
              jc --ini <~/.aws/config | jq 'to_entries | .[] | select(.value.sso_account_id == "'"$aws_account_id"'") | .key | split("\\s+"; "")[1]' -Mr
            }
          '';
          envExtra = ''
            export AWS_PAGER=""
          '';
        };

        xdg.configFile."zsh/functions/aws-profile".source =
          ./zsh/functions/aws-profile;
      }
    )
  ]
