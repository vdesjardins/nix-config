{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  jq,
}:
buildNpmPackage rec {
  pname = "opencode-skills";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "malhashemi";
    repo = "opencode-skills";
    rev = "v${version}";
    hash = "sha256-YajcjnJCOmY+cgtCDx6eySQa2f6acmzWR7AftZBBsTY=";
  };

  npmDepsHash = "sha256-w4REdyRFe5Ix0YBXVj/1LKfiS7LmIbq0jp8XOyttFdc=";

  postPatch = ''
    ${lib.getExe jq} '
      .dependencies += (.peerDependencies // {}) |
      . as $all | .devDependencies |= with_entries(
        select(.key as $k | ($all.dependencies | has($k) | not))
      ) |
      del(.peerDependencies)
    ' package.json > package-tmp.json && mv package-tmp.json package.json
  '';

  meta = with lib; {
    description = "Opencode skills plugin";
    homepage = "https://github.com/malhashemi/opencode-skills";
    license = licenses.mit;
    mainProgram = "opencode-skills";
  };
}
