{
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = "35260397545e523178b31ab46ad6417652152265";
    hash = "sha256-AvIEQBOT5Jp5O70TH2tfDI+OiJ2LVXTUzUGz7XrfKX4=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-fetch";
    version = "2026.1.14";

    inherit src;

    build-system = [python3Packages.hatchling];

    pythonRelaxDeps = ["httpx"];
    dependencies = with python3Packages; [
      httpx
      markdownify
      mcp
      protego
      pydantic
      (readabilipy.overridePythonAttrs
        (_p: {
          doCheck = false;
        }))
      requests
    ];

    patches = [./httpx-0.28.patch];

    pyproject = true;

    sourceRoot = "${src.name}/src/fetch";

    meta = {
      description = "Fetch MCP Server";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/fetch";
      mainProgram = "mcp-server-fetch";
    };
  }
