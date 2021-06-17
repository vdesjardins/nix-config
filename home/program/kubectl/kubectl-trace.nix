{ pkgs, buildGoModule, ... }:
buildGoModule {
  name = "kubectl-trace";

  src = pkgs.fetchFromGitHub {
    owner = "iovisor";
    repo = "kubectl-trace";
    rev = "e3f4d2cab2a567b2d607dad95394d24677646b33";
    sha256 = "10g4gywnyyw4y648lwir93x3x1kx7ab0sw2c8xg768qqk237nvs1";
  };

  doCheck = false;

  vendorSha256 = null;
}
