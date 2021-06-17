{ pkgs, ... }:

{
  users.users.vdesjardins = {
    description = "Vincent Desjardins";
    isHidden = false;
    home = /Users/vdesjardins;
    createHome = true;
    shell = pkgs.zsh;
  };

  nix.trustedUsers = [ "vdesjardins" ];
}
