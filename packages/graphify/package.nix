{
  lib,
  python312Packages,
  fetchPypi,
}:
python312Packages.buildPythonPackage rec {
  pname = "graphifyy";
  version = "0.8.28";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OvHhzevZmxeypy7viIPLFBTFQoBdQ/ygfIML01ODFyo=";
  };

  # Remove deps that cannot be satisfied from nixpkgs:
  #   datasketch → cassandra-driver → … → sphinx-9 (broken even on python3.12)
  #   rapidfuzz  → scikit-build-core → … → sphinx-9 (broken even on python3.12)
  # All "tree-sitter-<lang>" bindings are stripped here and satisfied instead
  # by the full python312Packages.tree-sitter-grammars scope below, whose
  # Python wrapper packages carry different distribution names and would fail
  # the runtime dep name check if left declared.
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
      networkx
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
