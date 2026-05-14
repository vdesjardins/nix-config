{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mcp-server-kubernetes";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "Flux159";
    repo = "mcp-server-kubernetes";
    rev = "v${version}";
    hash = "sha256-yWou0/OYJPZPVFflMChCFhMMy8MVU11+iGQHMGs8UfQ=";
  };

  npmDepsHash = "sha256-x6joNM7LPrm2TjQ1S7LB03lbaofq1u1XvR/LT6Klfyw=";

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
