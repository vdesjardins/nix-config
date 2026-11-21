inputs: _final: prev: {
  # The vendored JSON library in 0.0.4 loops in SemanticError.Is with Go 1.27.
  # Use the stable toolchain/package until its Kubernetes dependencies catch up.
  kubectl-validate = inputs.nixpkgs-2605.legacyPackages.${prev.stdenv.hostPlatform.system}.kubectl-validate;
}
