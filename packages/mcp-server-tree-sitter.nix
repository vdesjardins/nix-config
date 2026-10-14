{
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication {
  pname = "mcp-server-tree-sitter";
  version = "0.7.0-unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "wrale";
    repo = "mcp-server-tree-sitter";
    rev = "10c78c9d8aaf10d26ba550edbcdb822e87147bf8";
    hash = "sha256-Cq0WQkXhZOf33GOZbbVNhbbkM5brPgwru9ZRtUL/eGM=";
  };

  dependencies = with python3Packages; [
    mcp
    pydantic
    pygments
    pyyaml
    types-pyyaml
    tree-sitter
    tree-sitter-language-pack
  ];

  # The language pack in nixpkgs uses tree-sitter 0.25; allow that minor version.
  pythonRelaxDeps = ["tree-sitter"];
  pythonImportsCheck = ["mcp_server_tree_sitter"];

  build-system = [python3Packages.hatchling];
  pyproject = true;

  meta = {
    description = "MCP Server for Tree-sitter";
    homepage = "https://github.com/wrale/mcp-server-tree-sitter";
    mainProgram = "mcp-server-tree-sitter";
  };
}
