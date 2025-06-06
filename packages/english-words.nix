{
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./english-words.json);
in
  stdenv.mkDerivation {
    pname = "english-words";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "dwyl";
      repo = "english-words";
      rev = versioning.revision;
      hash = versioning.hash;
    };

    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      mkdir -p $out/share/english-words
      cp words*.txt $out/share/english-words/
      cp words*.json $out/share/english-words/
    '';

    meta = with lib; {
      description = "📝 A text file containing 479k English words for all your dictionary/word-based projects e.g: auto-completion / autosuggestion";
      homepage = "https://github.com/dwyl/english-words";
      platforms = platforms.all;
    };
  }
