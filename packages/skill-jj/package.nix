{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-jj";
  version = "0.61.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "9697a122369ef8fb4eee8822765b9d96bf770831";
    sha256 = "sha256-sH6qGztZD2azM9/YLp1yy8+aVZVK6e0XkhFuDUEgGQs=";
  };

  sourceRoot = "source/plugins/jj";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/jj
    cp -r . ${placeholder "out"}/skills/jj/
  '';
}
