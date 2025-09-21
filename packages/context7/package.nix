{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
in
  buildNpmPackage rec {
    pname = "context7";
    version = "1.0.17";

    src = fetchFromGitHub {
      owner = "upstash";
      repo = "context7";
      rev = "v${version}";
      hash = "sha256-X4I36pqGmIRbWqLiREoM1xU93VV1s4iuEnAEuXLk9yY=";
    };

    npmDepsHash = "sha256-xGI0gpKyY/G/YlrQk/1bryy+qto41XeUJz8cQXKUBOU=";

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
