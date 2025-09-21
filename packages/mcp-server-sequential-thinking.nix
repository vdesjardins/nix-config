{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-sequential-thinking";
    version = "2025.8.13";

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-f/lrUordxq1MzSHg+UdKkozNLxJC/7C+1B6G1Ylbcvs=";
    };

    npmDepsHash = "sha256-qIsj4XCMqFxqsfjZzs/eDM57U+BI3yJ6h6sdMHXgLvU=";

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
