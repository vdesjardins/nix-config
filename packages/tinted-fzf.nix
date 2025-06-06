{
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./tinted-fzf.json);
in
  stdenv.mkDerivation {
    pname = "tinted-fzf";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "tinted-theming";
      repo = "tinted-fzf";
      rev = versioning.revision;
      hash = versioning.hash;
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
