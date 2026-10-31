{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-files-widget";
  version = "usage-extension/v0.10.2-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "tmustier";
    repo = "pi-extensions";
    rev = "f2632e7da3cadc4f22fb8367e7c4454779ec1a05";
    hash = "sha256-Ajz98wOTsQKzJZh04tK0EiDEPywMUFIucGdTDp/QVV8=";
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
