{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "parallel-agent-skills";
  version = "main";

  src = fetchFromGitHub {
    owner = "parallel-web";
    repo = "parallel-agent-skills";
    rev = "c618686fdd9ac27dc274640d57aef8c10cc7c012";
    hash = "sha256-YJuA0Mx3Cpsbvdqe+Yv5u/aN4AJ4QiH2lpl8JImJiqE=";
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
