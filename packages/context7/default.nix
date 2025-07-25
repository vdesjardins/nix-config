{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}: let
in
  buildNpmPackage rec {
    pname = "context7";
    version = "1.0.14";

    src = fetchFromGitHub {
      owner = "upstash";
      repo = "context7";
      rev = "v${version}";
      hash = "sha256-41CIl3+psA/UPYclq7hnNvuhAaUg9NPuAZETGPbrydo=";
    };

    npmDepsHash = "sha256-wGseRqtuebQ9S7zugnqpPYnBSeKDjq2jFtV4JCd+vzw=";

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
