{
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./lscolors.json);
in
  stdenv.mkDerivation {
    pname = "lscolors";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "trapd00r";
      repo = "LS_COLORS";
      rev = versioning.revision;
      hash = versioning.hash;
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
