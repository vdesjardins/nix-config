{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-sequential-thinking";
    version = "2025.9.25";

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-ysTuSHFs7GABMuFXG+DcyonVXVs7m45j9sDPdHBS2wQ=";
    };

    npmDepsHash = "sha256-iRPILytyloL6qRMvy2fsDdqkewyqEfcuVspwUN5Lrqw=";

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
