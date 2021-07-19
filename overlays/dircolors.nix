inputs: _self: super: {
  lscolors = super.stdenv.mkDerivation {
    name = "lscolors";

    src = inputs.lscolors;

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/lscolors
      cp LS_COLORS $out/share/lscolors/LS_COLORS
    '';
  };
}
