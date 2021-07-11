{ pkgs, ... }:

{
  users.users.vdesjardins = {
    uid = 504;
    description = "Vincent Desjardins";
    isHidden = false;
    home = "/Users/vdesjardins";
    createHome = true;
    shell = pkgs.zsh;
  };
}
