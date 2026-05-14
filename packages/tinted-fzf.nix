{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-fzf";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "996e96cc8c209abe36eeb39ee8ffb5c4ba526be6";
    hash = "sha256-nX/m8Hkx0zZnlCJoqlcdugt6PjrDkZcylf76Vv2W2jQ=";
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
