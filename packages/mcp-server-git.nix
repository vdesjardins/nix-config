{
  lib,
  python3Packages,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./mcp-server-git.json);

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    rev = versioning.revision;
    hash = versioning.hash;
  };
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-git";
    version = versioning.version;

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
