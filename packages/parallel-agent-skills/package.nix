{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "parallel-agent-skills";
  version = "0.9.0-unstable-2026-10-05";

  src = fetchFromGitHub {
    owner = "parallel-web";
    repo = "parallel-agent-skills";
    rev = "92694a248ce444fb74d9bc120a9b93e69316b9f8";
    hash = "sha256-PwzWEzLfdz+lndID/HiLnZxNrPwT3ngC35sUQw3YgB4=";
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
