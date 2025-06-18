{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "lscolors";
  version = "0-unstable-2025-06-06";

  src = fetchFromGitHub {
    owner = "trapd00r";
    repo = "LS_COLORS";
    rev = "810ce8cac886ac50e75d84fb438b549a1f9478ee";
    hash = "sha256-MMzNknuELhpSkvcPgCL2Pp5A6DZrLajkz8qLphSNbjY=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/lscolors
    cp LS_COLORS $out/share/lscolors/LS_COLORS
  '';

  meta = with lib; {
    description = "A collection of LS_COLORS definitions; needs your contribution";
    homepage = "https://github.com/trapd00r/LS_COLORS";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    mainProgram = "lscolors";
    platforms = platforms.all;
  };
}
