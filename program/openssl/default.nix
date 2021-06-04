{ config, lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ openssl ];

  xdg.configFile."zsh/functions/tls-server-dump".source =
    mkIf config.programs.zsh.enable ./zsh/functions/tls-server-dump;
}
