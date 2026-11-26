{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "parallel-agent-skills";
  version = "0.12.0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "parallel-web";
    repo = "parallel-agent-skills";
    rev = "dd80868eaf6f58f84c33b87c66c4a216ebf53b8a";
    hash = "sha256-/J2zH/4jPf3u63oGgP71B1OaWUl3gWqvSLCcM08iKfY=";
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
