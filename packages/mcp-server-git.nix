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
    pname = "mcp-server-git";
    version = "2025.11.25";

    inherit src;

    propagatedBuildInputs = with python3Packages; [
      uv
      hatchling
      click
      gitpython
      mcp
      pydantic
    ];

    pyproject = true;

    sourceRoot = "${src.name}/src/git";

    meta = {
      description = "Git MCP Server";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/git";
      mainProgram = "mcp-server-git";
    };
  }
