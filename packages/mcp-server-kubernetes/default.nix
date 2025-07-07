{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-kubernetes";
    version = "2.5.0";

    src = fetchFromGitHub {
      owner = "Flux159";
      repo = "mcp-server-kubernetes";
      rev = "v${version}";
      hash = "sha256-cW5XisSFj0L8QoT1myy/0ruiJmZiUaYDwpbW4O6KwbE=";
    };

    npmDepsHash = "sha256-2LOVQKk7Df4Ot1qznyCfb0BxAMeRcjt5RiG5pp08Wr8=";

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
