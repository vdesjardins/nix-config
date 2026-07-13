{
  lib,
  python312Packages,
  fetchPypi,
}:
python312Packages.buildPythonPackage rec {
  pname = "graphifyy";
  version = "0.9.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bo9tJVm1y12yxakY7tVrhBu3kf26WUr8q4+LIxShL78=";
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

  propagatedBuildInputs =
    (with python312Packages; [
      datasketch
      networkx
      rapidfuzz
      tree-sitter
    ])
    ++ (builtins.attrValues (
      builtins.removeAttrs python312Packages.tree-sitter-grammars [
        "recurseForDerivations"
        # Packages with test failures in nixpkgs (not marked broken upstream)
        "tree-sitter-agda"
        "tree-sitter-fstar"
        "tree-sitter-dtd"
        "tree-sitter-go-template-helm"
        "tree-sitter-gren"
        "tree-sitter-ocaml-interface"
        "tree-sitter-opam"
        "tree-sitter-quint"
        "tree-sitter-strace"
        "tree-sitter-tact"
        "tree-sitter-tsx"
        "tree-sitter-vue"
      ]
    ));

  doCheck = false;

  meta = with lib; {
    description = "Claude Code skill — turn any folder of code, docs, papers, images, or tweets into a queryable knowledge graph";
    homepage = "https://github.com/safishamsi/graphify";
    license = licenses.mit;
    mainProgram = "graphify";
  };
}
