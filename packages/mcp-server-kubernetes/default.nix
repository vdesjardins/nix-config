{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-kubernetes";
    version = "2.4.7";

    src = fetchFromGitHub {
      owner = "Flux159";
      repo = "mcp-server-kubernetes";
      rev = "v${version}";
      hash = "sha256-NUKDoispVfLwARdzuh0R6Jya9XslbiEREsCAv7OdMfM=";
    };

    npmDepsHash = "sha256-AS9S/3tAGCnaIrQ9kgXiLaBBJ+8626lJAHDBcMIw/Yc=";

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
