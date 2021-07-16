{ pkgs }: pkgs.stdenv.mkDerivation {
  name = "kubectl-view-utilization";

  buildInputs = with pkgs; [ bash gawk ];

  src = pkgs.fetchFromGitHub {
    owner = "etopeter";
    repo = "kubectl-view-utilization";
    rev = "ec114ef3bf9609e8dff9b952fa10c6a75b94f570";
    sha256 = "15cjq19xx516ha0w4hwbw720ly21a8m3f34vs4a1ki0w63h9qsp2";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "postFixupPhase" ];

  postFixupPhase = ''
    substituteInPlace $out/bin/kubectl-view-utilization \
      --replace " awk " " ${pkgs.gawk}/bin/awk "
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kubectl-view-utilization $out/bin/
    chmod +x $out/bin/kubectl-view-utilization
  '';
}
