{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}:
buildNpmPackage rec {
  pname = "mcp-server-sequential-thinking";
  version = "2025.12.18";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = version;
    hash = "sha256-Km0MjjZhhijynYyju3tMJwsplrpNUr4cJ95TxqgrrR8=";
  };

  npmDepsHash = "sha256-wluSvNnZcIz2XyXqmmego+vYThT3EtzakJsamzhgb6g=";

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
