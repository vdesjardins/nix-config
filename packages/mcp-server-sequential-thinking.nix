{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
}:
buildNpmPackage rec {
  pname = "mcp-server-sequential-thinking";
  version = "2026.6.3";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = version;
    hash = "sha256-C5wE5ChDI1w4fh5LC1gV9WFuKMVfwvSnS18Fi2s+t+s=";
  };

  npmDepsHash = "sha256-SJinA76eznhFfE1qzzIhoi5kKCohLYT1YikWLrzWGW4=";

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
