{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}:
buildNpmPackage rec {
  pname = "mcp-server-sequential-thinking";
  version = "2025.11.25";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = version;
    hash = "sha256-o39XF/8EQG1Ft3FDbGKwnhsz+bwSCqqoPgVvcyc+c2k=";
  };

  npmDepsHash = "sha256-GQYLDBwmcaWcUmklFkyivBuVAEblXIsXdnxIJOcibIw=";

  npmWorkspace = "src/sequentialthinking";

  nativeBuildInputs = [
    typescript
    (writeScriptBin "shx" "")
  ];

  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Sequential Thinking MCP Server";
    homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking";
    mainProgram = "mcp-server-sequential-thinking";
  };
}
