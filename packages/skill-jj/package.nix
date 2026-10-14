{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "0.57.0-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "f6a24dbc08da57aeb80e7423da2508457d0b3398";
    sha256 = "sha256-M9IiVYhO8aDdzWmsKXkFiLGAWLexAHv1F7TbMwkc3XQ=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
