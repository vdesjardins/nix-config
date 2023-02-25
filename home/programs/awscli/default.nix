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
