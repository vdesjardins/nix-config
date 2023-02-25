{pkgs, ...}: {
  users.users.vince = {
    uid = 501;
    description = "Vincent Desjardins";
    isHidden = false;
    home = "/Users/vince";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
