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
    rev = "bbb701e7ac1e57f3edd1c2836b94c5457eaf7b9c";
    hash = "sha256-KyfmTBoYFKWD/kjKoPPA5fdpsq0Ja5K/0yVk7i8zeqY=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "2026.8.31-unstable-2026-10-11";

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
