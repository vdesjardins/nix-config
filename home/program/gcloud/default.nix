{ pkgs, ... }:
{
  home.packages = with pkgs; [
    google-cloud-sdk
  ];

  programs.zsh.initExtra = ''
    source ${pkgs.google-cloud-sdk}/google-cloud-sdk/completion.zsh.inc
  '';
}
