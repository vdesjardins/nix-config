{ config, lib, pkgs, ... }:
let static-tcpdump = pkgs.callPackage ./static-tcpdump.nix { };
in
pkgs.buildGoModule rec {
  name = "ksniff";

  buildInputs = with pkgs; [ kubectl go gnumake wget ];

  src = pkgs.fetchFromGitHub {
    owner = "eldadru";
    repo = "ksniff";
    rev = "2a05fe8090aad1a02d4923678be5b15458bbc9ac";
    sha256 = "0n1gkf9rympz2k1zilgrc9bgdd07w2xz38hv97f0m3hzy8z87n3q";
  };

  subPackages = [ "cmd" ];

  vendorSha256 = "00azb3pgdbyqnf002n3vhi1v3815lz1sr12xglh12flc5llcqlv2";

  doCheck = false;

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-sniff
    ln -s ${static-tcpdump}/sbin/static-tcpdump $out/bin/static-tcpdump
  '';
}
