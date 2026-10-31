{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mcp-server-kubernetes";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Flux159";
    repo = "mcp-server-kubernetes";
    rev = "v${version}";
    hash = "sha256-lMgVBC4OjAbpxLcTUNLenB9iNaiuil6GZibhBFyRotg=";
  };

  npmDepsHash = "sha256-fBz3I6CGyxxLw0M61TTDWBPJ+FMbgEPzDiDzV50uaCE=";

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
