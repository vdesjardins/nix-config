{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
in
  buildNpmPackage rec {
    pname = "context7";
    version = "1.0.21";

    src = fetchFromGitHub {
      owner = "upstash";
      repo = "context7";
      rev = "v${version}";
      hash = "sha256-F4IiS5hIutVt2XSNGr3vhEy7kr/ad8WtstX5rZVuIao=";
    };

    npmDepsHash = "sha256-XtZoKs2NGZY+TjLtr3Yeo4pHnNd0XHPYvpr7ASAg+As=";

    packageLock = ./package-lock.json;

    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    meta = with lib; {
      description = "Context7 MCP Server -- Up-to-date code documentation for LLMs and AI code editors ";
      homepage = "https://github.com/upstash/context7";
      license = licenses.mit;
      mainProgram = "context7-mcp";
    };
  }
