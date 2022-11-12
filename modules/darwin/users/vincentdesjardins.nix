{ pkgs, ... }:
{
  users.users.vincentdesjardins = {
    uid = 501;
    description = "Vincent Desjardins";
    isHidden = false;
    home = "/Users/vincentdesjardins";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
