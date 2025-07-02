{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-kubernetes";
    version = "2.4.9";

    src = fetchFromGitHub {
      owner = "Flux159";
      repo = "mcp-server-kubernetes";
      rev = "v${version}";
      hash = "sha256-Z1idkvgqus4bjtBToemmREGeiCjbhcDQ3LKvDvEW0YU=";
    };

    npmDepsHash = "sha256-1SNUVKUoeOxNcypbtpf8QN4+OQyVO172COzvz8fpop8=";

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
