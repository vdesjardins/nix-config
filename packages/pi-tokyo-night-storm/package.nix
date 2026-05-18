{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-tokyo-night-storm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sanathks";
    repo = "pi-tokyo-night-storm";
    rev = "cc44249b7d977201049deefdf4b0319b24afb4c2";
    hash = "sha256-PiNyfGwqQwA6M8sttld/kTZ8idX/xd88PNl4DyNGaRE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r themes package.json $out/
  '';

  meta = with lib; {
    description = "Tokyo Night Storm theme for pi coding agent";
    homepage = "https://github.com/sanathks/pi-tokyo-night-storm";
    license = licenses.mit;
  };
}
