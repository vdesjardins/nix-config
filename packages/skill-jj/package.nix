{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "0.58.1-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "8c15cbba6eea860c4161bf3b2e0ea11be9ca4942";
    sha256 = "sha256-cr/wlwXk+SIvHEN+9kVsE59gX/0EWF+5JKYFs6Va4k8=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
