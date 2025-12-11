{pkgs, ...}: {
  users.users.inf10906 = {
    uid = 502;
    description = "Vincent Desjardins";
    isHidden = false;
    home = "/Users/inf10906";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  security.pki.certificateFiles = [
    ../../../../misc/certs/zscaler-from-office.pem
    ../../../../misc/certs/zscaler-root-cert.pem
  ];
}
