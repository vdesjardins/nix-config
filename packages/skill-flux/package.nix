{stdenv}:
stdenv.mkDerivation {
  pname = "skill-flux";
  version = "0.1.0";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/skills/flux
    cp -r . $out/skills/flux/
  '';
}
