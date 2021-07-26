{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ aws-iam-authenticator awscli2 ];

  programs.zsh.initExtra = ''
    complete -C ${pkgs.awscli2}/bin/aws_completer aws
  '';
}
