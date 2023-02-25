inputs: _self: super: {
  kubectl-view-utilization = super.stdenv.mkDerivation {
    name = "kubectl-view-utilization";

    buildInputs = with super; [bash gawk];

    src = inputs.kubectl-view-utilization;

    phases = ["unpackPhase" "installPhase" "fixupPhase" "postFixupPhase"];

    postFixupPhase = ''
      substituteInPlace $out/bin/kubectl-view-utilization \
        --replace " awk " " ${super.gawk}/bin/awk "
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp kubectl-view-utilization $out/bin/
      chmod +x $out/bin/kubectl-view-utilization
    '';
  };
}
