{
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  writeScriptBin,
}: let
in
  buildNpmPackage rec {
    pname = "mcp-server-sequential-thinking";
    version = "2025.7.1";

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-Ujzr3F34550JA/hxKmFHXugX41duxcUVXU4nYmlMtDs=";
    };

    npmDepsHash = "sha256-5QT6d4SpdPHJC55s9k3/qDmzo9C7tr/9RDYHR6sqMpw=";

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
