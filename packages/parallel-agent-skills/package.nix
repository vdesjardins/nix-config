{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "parallel-agent-skills";
  version = "0.9.0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "parallel-web";
    repo = "parallel-agent-skills";
    rev = "0c04632b7ca4429651c405bf5f411c4dcb62f5f4";
    hash = "sha256-YqU3xjylEHp9zhgJHPaw6y3+RcBFtOV5rk8oDnYh794=";
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
