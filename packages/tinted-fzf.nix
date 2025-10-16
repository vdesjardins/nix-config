{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-fzf";
  version = "0-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "1831ad684d0d6c834c2be1446f10105199a23af0";
    hash = "sha256-OXy55PL/OjHAsUINVNdPUZPZyQIGtblP6mC7xXjxCCw=";
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
