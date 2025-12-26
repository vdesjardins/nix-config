{
  python3Packages,
  fetchFromGitHub,
}: let
in
  python3Packages.buildPythonApplication {
    pname = "mcp-server-tree-sitter";
    version = "main";

    src = fetchFromGitHub {
      owner = "wrale";
      repo = "mcp-server-tree-sitter";
      rev = "a10571771f509d60ffff33752d97689bf18dd893";
      hash = "sha256-g1DWaUk4842YzZ4VldowNcRatcFCuuc8VTpxgTbEUQ8=";
    };

    dependencies = with python3Packages; [
      mcp
      pydantic
      pyyaml
      types-pyyaml
      tree-sitter
      tree-sitter-language-pack
    ];

    build-system = [python3Packages.hatchling];
    pyproject = true;

    meta = {
      description = "MCP Server for Tree-sitter";
      homepage = "https://github.com/wrale/mcp-server-tree-sitter";
      mainProgram = "mcp-server-tree-sitter";
    };
  }
