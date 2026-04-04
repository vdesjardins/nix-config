{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mcp-server-kubernetes";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "Flux159";
    repo = "mcp-server-kubernetes";
    rev = "v${version}";
    hash = "sha256-NZnAnBdYI72rNvnJRgXjt9eNm8l2qRyy0ZGZQqFM6AM=";
  };

  npmDepsHash = "sha256-QF0WqjCqKy9pkG1d4Z9riT0MZ2CUwFX04dnc4+Hkv/E=";

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
