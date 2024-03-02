{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "lscolors";
  version = "unstable-2023-12-13";

  src = fetchFromGitHub {
    owner = "trapd00r";
    repo = "LS_COLORS";
    rev = "a283d79dcbb23a8679f4b1a07d04a80cab01c0ba";
    hash = "sha256-DT9WmtyJ/wngoiOTXMcnstVbGh3BaFWrr8Zxm4g4b6U=";
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
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "lscolors";
    platforms = platforms.all;
  };
}
