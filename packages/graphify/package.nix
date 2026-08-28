{
  lib,
  python312Packages,
  fetchPypi,
}:
python312Packages.buildPythonPackage rec {
  pname = "graphifyy";
  version = "0.9.50";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F1j6lzqKbcJ8pScezz71X6YZ2nehEgv4v2hahl8gKD8=";
  };

  # Strip tree-sitter bindings from pyproject.toml and satisfy them from the
  # full python312Packages.tree-sitter-grammars scope below.
  postPatch = ''
    sed -i \
      -e '/"datasketch",/d' \
      -e '/"rapidfuzz",/d' \
      -e '/"tree-sitter-/d' \
      pyproject.toml
  '';

  nativeBuildInputs = with python312Packages; [setuptools];

  propagatedBuildInputs = let
    # Only ship the grammars Graphify declares as runtime dependencies. The full
    # nixpkgs grammar scope includes hundreds of unrelated and broken packages.
    grammar = name:
      python312Packages.tree-sitter-grammars.${name}.overridePythonAttrs (_old: {
        # Some generated grammar wheels do not include distribution metadata.
        dontCheckPythonMetadata = true;
      });
  in
    (with python312Packages; [
      datasketch
      networkx
      rapidfuzz
      tree-sitter
    ])
    ++ (map grammar [
      "tree-sitter-python"
      "tree-sitter-javascript"
      "tree-sitter-typescript"
      "tree-sitter-go"
      "tree-sitter-rust"
      "tree-sitter-java"
      "tree-sitter-groovy"
      "tree-sitter-c"
      "tree-sitter-cpp"
      "tree-sitter-ruby"
      "tree-sitter-c-sharp"
      "tree-sitter-kotlin"
      "tree-sitter-scala"
      "tree-sitter-php"
      "tree-sitter-swift"
      "tree-sitter-lua"
      "tree-sitter-zig"
      "tree-sitter-powershell"
      "tree-sitter-elixir"
      "tree-sitter-objc"
      "tree-sitter-julia"
      "tree-sitter-verilog"
      "tree-sitter-fortran"
      "tree-sitter-bash"
      "tree-sitter-json"
    ]);

  doCheck = false;

  meta = with lib; {
    description = "Claude Code skill — turn any folder of code, docs, papers, images, or tweets into a queryable knowledge graph";
    homepage = "https://github.com/safishamsi/graphify";
    license = licenses.mit;
    mainProgram = "graphify";
  };
}
