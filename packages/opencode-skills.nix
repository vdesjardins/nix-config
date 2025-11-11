{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  jq,
}: let
in
  buildNpmPackage rec {
    pname = "opencode-skills";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "malhashemi";
      repo = "opencode-skills";
      rev = "v${version}";
      hash = "sha256-36KVZ4kVpUnUld6eWNxWTS+L0LIapiACYmNBdAbvzgQ=";
    };

    npmDepsHash = "sha256-2tGVhEDgBMPVm21DYeZ0WuXGpEpCj/1ULK81AzwI7eg=";

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
