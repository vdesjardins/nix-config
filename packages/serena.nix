{
  pkgs,
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "a78fe030e87a5ca0b0e78a07e6115c0c4b9ec7b5";
    hash = "sha256-A41Y1tJEqQEkihZIDLgHg24i5E9qyZ3HJrjFrHOv28I=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "serena";
    version = "2025-06-20-unstable-2025-07-07";

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
