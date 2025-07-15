{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-kubernetes";
    version = "2.5.1";

    src = fetchFromGitHub {
      owner = "Flux159";
      repo = "mcp-server-kubernetes";
      rev = "v${version}";
      hash = "sha256-Nm4XStaGYzXaOg+80C7JZQgqalzUqi3MwxAHThEMDw0=";
    };

    npmDepsHash = "sha256-3Dj3bsuTiie/goWBjCjZeedijoU+nnDWHavYNNzdexI=";

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
