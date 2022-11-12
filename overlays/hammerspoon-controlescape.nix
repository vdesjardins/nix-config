inputs: _self: super: {
  hammerspoon-controlescape = super.stdenv.mkDerivation {
    name = "hammerspoon-controlescape";

    src = inputs.hammerspoon-controlescape;

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/hammerspoon/controlescape
      cp -r . $out/share/hammerspoon/controlescape/
    '';
  };
}
