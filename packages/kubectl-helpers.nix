{
  lib,
  stdenv,
  makeWrapper,
  kubectl,
  fzf,
  jq,
  awscli2,
  google-cloud-sdk,
  python3Packages,
}:
stdenv.mkDerivation {
  pname = "kubectl-helpers";
  version = "1.0.0";

  src = ../home/modules/modules/shell/tools/kubectl/scripts;

  nativeBuildInputs = [makeWrapper];

  buildInputs = [
    kubectl
    fzf
    jq
    awscli2
    google-cloud-sdk
    python3Packages.jc
  ];

  installPhase = ''
    mkdir -p $out/bin

    # Install all scripts
    for script in $src/*; do
      if [ -f "$script" ]; then
        cp "$script" "$out/bin/$(basename "$script")"
        chmod +x "$out/bin/$(basename "$script")"
      fi
    done

    # Wrap scripts with runtime dependencies
    for script in $out/bin/*; do
      wrapProgram "$script" \
        --prefix PATH : ${lib.makeBinPath [
      kubectl
      fzf
      jq
      awscli2
      google-cloud-sdk
      python3Packages.jc
    ]}
    done
  '';

  meta = with lib; {
    description = "Kubernetes helper scripts for context/namespace switching and cluster management";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
