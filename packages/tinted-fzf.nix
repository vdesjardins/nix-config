{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-fzf";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "3918c6924810853d8a51ddfd7ab63d4b3359b63c";
    hash = "sha256-sT6Pxp2Tcx1fjpDKq8A57Sjqs7iE2qtYXFo/WYIreYY=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/tinted-fzf
    cp -a ./bash $out/share/tinted-fzf/
    cp -a ./fish $out/share/tinted-fzf/
  '';

  meta = with lib; {
    description = "Base16 and base24 colorschemes for fzf";
    homepage = "https://github.com/tinted-theming/tinted-fzf";
    license = licenses.mit;
    mainProgram = "tinted-fzf";
    platforms = platforms.all;
  };
}
