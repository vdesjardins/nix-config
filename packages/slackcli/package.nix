{
  bun,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "slackcli";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    rev = "v${version}";
    sha256 = "sha256-J5Yg62vGlnKWww0aE/jAm0RVHeYFPkElCX3l93UI4ww=";
  };

  npmDepsHash = "sha256-+QaSd55XtRSsLSC3qJzdxqxCyE1HHR2dGgBf1vbNy7U=";

  packageLock = ./package-lock.json;

  nativeBuildInputs = [bun];

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./dist/slackcli $out/bin/slackcli
    chmod +x $out/bin/slackcli
  '';

  meta = with lib; {
    description = "Fast CLI tool for interacting with Slack workspaces and channels";
    homepage = "https://github.com/shaharia-lab/slackcli";
    license = licenses.mit;
    mainProgram = "slackcli";
  };
}
