{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-files-widget";
  version = "usage-extension/v0.3.1";

  src = fetchFromGitHub {
    owner = "tmustier";
    repo = "pi-extensions";
    rev = "240b370181ee353c0be8ceaa054d3e2f7ae7b60f";
    hash = "sha256-O1YKHxIgZhinh6o0RZgdkOpi4nC2ie9hjzDadqgv+DY=";
  };

  sourceRoot = "source/files-widget";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r *.ts package.json $out/
  '';

  meta = with lib; {
    description = "In-terminal file browser and viewer for Pi";
    homepage = "https://github.com/tmustier/pi-extensions/tree/main/files-widget";
    license = licenses.mit;
  };
}
