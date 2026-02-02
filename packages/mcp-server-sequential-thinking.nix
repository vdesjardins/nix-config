{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
}:
buildNpmPackage rec {
  pname = "mcp-server-sequential-thinking";
  version = "2026.1.26";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = version;
    hash = "sha256-uULXUEHFZpYm/fmF6PkOFCxS+B+0q3dMveLG+3JHrhk=";
  };

  npmDepsHash = "sha256-jmz4JdpeHH07vJQFntBwrENbJaIcOuZMb7+qf497VOE=";

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
