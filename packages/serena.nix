{
  pkgs,
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "b1eba4563e7f892c96e2b8e97ca871984b4d2e08";
    hash = "sha256-WCwda+TYTikn1NjSK9eLEcJXrz71qZazfnLU9mbTTjE=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "serena";
    version = "2025-06-20";

    inherit src;

    propagatedBuildInputs = with python3Packages;
      [
        docstring-parser
        flask
        hatchling
        jinja2
        joblib
        mcp
        overrides
        psutil
        python-dotenv
        pyyaml
        requests
        ruamel-yaml
        sensai-utils
        tqdm
        types-pyyaml
        uv
      ]
      ++ (with pkgs; [
        pyright
      ]);

    pyproject = true;

    dontCheckRuntimeDeps = true;

    patches = [./serena-xdg-config.patch];

    meta = {
      description = "A powerful coding agent toolkit providing semantic retrieval and editing capabilities (MCP server & Agno integration)";
      homepage = "https://github.com/oraios/serena";
      mainProgram = "serena-mcp-server";
    };
  }
