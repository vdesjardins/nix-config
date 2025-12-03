{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mcp-server-kubernetes";
  version = "2.9.9";

  src = fetchFromGitHub {
    owner = "Flux159";
    repo = "mcp-server-kubernetes";
    rev = "v${version}";
    hash = "sha256-6pziQncG4N4zoGl4U4RMxlbbZj+zGAXRE2w82Mg6bv0=";
  };

  npmDepsHash = "sha256-3Ece5GGUfieaVwEi3YdqALoNsxE/9W1eKwqNy1Es8cs=";

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
