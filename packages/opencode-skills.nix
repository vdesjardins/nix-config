{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  jq,
}:
buildNpmPackage rec {
  pname = "opencode-skills";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "malhashemi";
    repo = "opencode-skills";
    rev = "v${version}";
    hash = "sha256-VWDtrGuedZLvr9HXVrZbjFQOcRKw3jN6i5+3XUe4TMs=";
  };

  npmDepsHash = "sha256-FlIf4TiEK2QhN+Cyv/7p7BEZa5rGgppVYPwsdgWV2jc=";

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
