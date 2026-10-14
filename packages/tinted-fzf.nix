{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-fzf";
  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "badd6a4275c977c32f0ba8e1b69e9bf5586cebc1";
    hash = "sha256-UM/F5C5gvpoUfxHP9fYN4p4rLvrnaQRycD6IFoBc2Fw=";
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
