{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-sequential-thinking";
    version = "2025.7.29";

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-JlUkWhcHLg8X0ON/g2wSkG8+jq+Cd6onOqo+3qfqsZk=";
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
