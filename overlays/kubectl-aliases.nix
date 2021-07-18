inputs: _self: super: {
  kubectl-aliases = super.stdenv.mkDerivation {
    name = "kubectl-aliases";

    src = inputs.kubectl-aliases;

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/kubectl-aliases
      cp .kubectl_aliases $out/share/kubectl-aliases/kubectl_aliases
    '';
  };
}
