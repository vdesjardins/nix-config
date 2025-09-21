{
  pkgs,
  python3Packages,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "111a764b0b79417ec8ce05752efe6d8d5e2bfab6";
    hash = "sha256-RzRP2PqTneCzC4jJk6jpdjBNZNXCJWyXzVseH0vsRdk=";
  };
in
  python3Packages.buildPythonApplication {
    pname = "serena";
    version = "0.1.3-unstable-2025-08-13";

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
