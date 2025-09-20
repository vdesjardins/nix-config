{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-kubernetes";
    version = "2.6.0";

    src = fetchFromGitHub {
      owner = "Flux159";
      repo = "mcp-server-kubernetes";
      rev = "v${version}";
      hash = "sha256-iIbvwS9aJKL08U2v/iYbdRP4puImNAhuYx4nr56HaAA=";
    };

    npmDepsHash = "sha256-KeUt8eXAaJWETz0RDw0VgrDhdLpfK23SgSkEOx3Ajpc=";

    packageLock = ./package-lock.json;

    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    meta = with lib; {
      description = "MCP Server for kubernetes management commands";
      homepage = "https://github.com/Flux159/mcp-server-kubernetes";
      license = licenses.mit;
      mainProgram = "mcp-server-kubernetes";
    };
  }
