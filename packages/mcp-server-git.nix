{
  python3Packages,
  fetchFromGitHub,
}: let
  # The current server requires GitPython >= 3.1.60, newer than nixpkgs.
  gitpython = python3Packages.gitpython.overridePythonAttrs {
    version = "3.2.0";
    src = fetchFromGitHub {
      owner = "gitpython-developers";
      repo = "GitPython";
      tag = "3.2.0";
      hash = "sha256-7y0733illPou3wL6mHlNCWKfLe72nXYU+BGDcYKH6jw=";
    };
  };

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = "c799c8552b0f27b7a33a7b9233773da144dddcf5";
    hash = "sha256-yYfNwuNwzgguvErZRzc+M7cDt/05pU7iZuiF1L3c4hE=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "2026.8.31-unstable-2026-11-18";

    inherit src;

    propagatedBuildInputs =
      [gitpython]
      ++ (with python3Packages; [
        uv
        hatchling
        click
        mcp
        pydantic
      ]);

    pyproject = true;

    sourceRoot = "${src.name}/src/git";

    meta = {
      description = "Git MCP Server";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/git";
      mainProgram = "mcp-server-git";
    };
  }
