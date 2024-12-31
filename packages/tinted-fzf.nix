{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "tinted-fzf";
  version = "unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "6feaca09573a2af3cd2c4bd5b3270e4f65719fbc";
    hash = "sha256-yEMwr2+rMev9YHtrY7qduNwX4gBIKSyX/HClqndu594=";
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
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "tinted-fzf";
    platforms = platforms.all;
  };
}
