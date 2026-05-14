{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-msfrrNvOKtB45WSNTGfMrJ6ACW40AYSeJmE3rsWVQe0=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
