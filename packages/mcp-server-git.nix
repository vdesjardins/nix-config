{
  lib,
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = "main";
    hash = "sha256-H2jvXHeeLFJ9Z2ZiX5gl3UudeVysdm653MbysCbpcKs=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = "2025-05-31";

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

    meta = with lib; {
      description = "Git MCP Server";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/git";
      maintainers = with maintainers; [vdesjardins];
      mainProgram = "mcp-server-git";
    };
  }
