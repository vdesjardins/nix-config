{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "parallel-agent-skills";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "parallel-web";
    repo = "parallel-agent-skills";
    rev = "1f7dd5ec8508b67b3fdc2ac3e0ecb2a15b56e939";
    hash = "sha256-zTnncugDZiyfjg1a2uzL2uK4nMZQE67h0LIsVhbu/lo=";
  };

  sourceRoot = "source/skills";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/skills
    cp -r . $out/skills/
  '';

  meta = with lib; {
    description = "Parallel Agent Skills for web search, extraction, deep research, and enrichment";
    homepage = "https://github.com/parallel-web/parallel-agent-skills";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [fromSource];
  };
}
