{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-BemrhS9llh13m8/oY7b31+zXv3uPFIPkoU+/kEcq3Lo=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
