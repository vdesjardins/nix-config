{
  pkgs,
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "f493f7a6c4e72259953a172b5710371c2cbb4ec2";
    hash = "sha256-Qo+QxAsYNieBOVX1JntTO7VrUasbSUEytZnAp8hHmps=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "serena";
    version = "2025-06-20-unstable-2025-07-02";

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
