{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-a4CYvUoWVrvWo79G8uakuBtgaJkiq8t70yYDQGtKVQQ=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
