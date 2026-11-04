{
  cacert,
  coreutils,
  fetchFromGitHub,
  gitMinimal,
  lib,
  openssh,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
  z3,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openshell";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "OpenShell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mBciX4fPWUtaszWhV8gCpYjQmuAJxKxkhwT6oVKq6jY=";
  };

  cargoHash = "sha256-4v3SuKRrEi97s4B1IDb0OCwo07/Ld4eKjgwYlXzYT+M=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [z3];

  nativeCheckInputs = [
    cacert
    gitMinimal
    openssh
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
    substituteInPlace Cargo.toml \
      --replace-fail 'members = ["crates/*"]' 'members = ["crates/openshell-cli"]'

    # Tests create shell scripts with FHS paths that do not exist in the Nix
    # build sandbox.
    substituteInPlace crates/openshell-core/src/e2fsprogs.rs \
      --replace-fail '#!/bin/sh' '#!${stdenv.shell}' \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  '';

  env.OPENSHELL_IMAGE_TAG = finalAttrs.version;

  doCheck = !stdenv.hostPlatform.isDarwin;
  preCheck = ''
    export HOME="$TMPDIR"
  '';
  checkFlags = [
    # Timing-sensitive under the Nix build sandbox; all other e2fsprogs
    # preflight tests remain enabled.
    "--skip=e2fsprogs::tests::filesystem_preflight_bounds_each_output_stream"
  ];

  nativeInstallCheckInputs = [versionCheckHook];
  doInstallCheck = true;

  meta = {
    description = "Safe, private runtime for autonomous AI agents";
    homepage = "https://github.com/NVIDIA/OpenShell";
    changelog = "https://github.com/NVIDIA/OpenShell/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "openshell";
    platforms = lib.platforms.all;
  };
})
