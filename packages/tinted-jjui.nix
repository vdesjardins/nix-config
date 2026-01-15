{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-jjui";
  version = "1.0-main";

  src = fetchFromGitHub {
    owner = "vic";
    repo = "tinted-jjui";
    rev = "main";
    hash = "sha256-MGk9d795AsXmjaIfCuGCNRig0ISTYA2PN2ySfRwdzRI=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/jjui/themes
    cp -r themes/*.toml $out/share/jjui/themes/
  '';

  meta = with lib; {
    description = "jjui themes from base16 and base24 color schemes";
    homepage = "https://github.com/vic/tinted-jjui";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
