{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-fzf";
  version = "0-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "8b8a768da3ade719c61bc5c452db4d6872368584";
    hash = "sha256-EGHgJw5wsC1gTJdg7AznH32ehKr5mA8/5J+fsHFDl4c=";
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
