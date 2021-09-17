{ config, pkgs, lib, ... }:
with lib;
mkMerge [
  {
    home.packages = with pkgs; [ aws-iam-authenticator awscli2 ];
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

      xdg.configFile."zsh/functions/aws_profile".source =
        ./zsh/functions/aws_profile;
    }
  )
]
