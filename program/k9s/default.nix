{ pkgs, ... }:

{
  home.packages = with pkgs; [ k9s ];

  home.file.".k9s/views.yml".source = ./views.yml;
}
