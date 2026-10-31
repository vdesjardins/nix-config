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
    rev = "194cc86e3ae6400958555bd4116849d822d69263";
    hash = "sha256-9dXpm2MRye4a3lEt2oYP/SO4tJmZ94HWL5mf/zlC5z4=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "2026.8.31-unstable-2026-10-28";

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
