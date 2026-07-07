{
  lib,
  python312Packages,
  fetchPypi,
}:
python312Packages.buildPythonPackage rec {
  pname = "graphifyy";
  version = "0.9.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fdv5v7Aaa3jXiLLNUW6IhJyRYeC8IH4vG3OjLYgCev0=";
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
        "tree-sitter-go-template-helm"
        "tree-sitter-gren"
        "tree-sitter-opam"
        "tree-sitter-quint"
        "tree-sitter-strace"
        "tree-sitter-tact"
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
