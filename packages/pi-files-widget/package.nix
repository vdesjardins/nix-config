{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-files-widget";
  version = "usage-extension/v0.9.5-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "tmustier";
    repo = "pi-extensions";
    rev = "4a63a2ebd3683d86597e226c7ff778ea4837dd73";
    hash = "sha256-CnU01tMeRf42wC5Rune0ANl9bv0mLM5iOCGUgX7W8D4=";
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
