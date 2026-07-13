{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
}:
buildNpmPackage rec {
  pname = "mcp-server-sequential-thinking";
  version = "2026.7.10";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = version;
    hash = "sha256-ORihWA8Xx7WAPo2+vRPpYNF9CGfc1sjmW+NfUKBGzxs=";
  };

  npmDepsHash = "sha256-KhlTXcS+VDSPGnEus9fA0xhIxfTGwX1Cr5hbxFvdc2k=";

  dontNpmPrune = true;

  npmWorkspace = "src/sequentialthinking";

  nativeBuildInputs = [
    typescript
  ];

  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Sequential Thinking MCP Server";
    homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking";
    mainProgram = "mcp-server-sequential-thinking";
  };
}
