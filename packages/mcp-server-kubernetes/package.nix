{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mcp-server-kubernetes";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Flux159";
    repo = "mcp-server-kubernetes";
    rev = "v${version}";
    hash = "sha256-bnGP5pmjGWDFu2HKS8S8YiNPipBAX4YI/vXI1YGmduE=";
  };

  npmDepsHash = "sha256-Y7k6TuI3n5LSJyL43GK7twT4vu/KnTCBeROvkIOc7ps=";

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
