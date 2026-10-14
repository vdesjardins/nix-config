{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-jjui";
  version = "1.0-1456ae608862d58f90442a9aa9ce571756eeac3f";

  src = fetchFromGitHub {
    owner = "vic";
    repo = "tinted-jjui";
    rev = "1456ae608862d58f90442a9aa9ce571756eeac3f";
    hash = "sha256-GMEiPQ3TIAyAeXFfahOYtCkXXq8FnJ2h+dLNywssZaE=";
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
