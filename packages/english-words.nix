{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "english-words";
  version = "0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "dwyl";
    repo = "english-words";
    rev = "20f5cc9b3f0ccc8ce45d814c532b7c2031bba31c";
    hash = "sha256-PfBQ9iavOLx7M8+j0TXASUxVamPiQn2YXsiuUmz4XCg=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/english-words
    cp words*.txt $out/share/english-words/
    cp words*.json $out/share/english-words/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };

  meta = with lib; {
    description = "📝 A text file containing 479k English words for all your dictionary/word-based projects e.g: auto-completion / autosuggestion";
    homepage = "https://github.com/dwyl/english-words";
    platforms = platforms.all;
  };
}
