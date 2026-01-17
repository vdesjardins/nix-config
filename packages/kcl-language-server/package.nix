{
  fetchFromGitHub,
  lib,
  pkg-config,
  protobuf,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "kcl-language-server";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "main";
    hash = "sha256-3aA3+TpCMqVgKNyFzP0rhzgSZPBxaoFgniy7k6vAtfU=";
  };

  # Set the sourceRoot to the repository root so Cargo.lock is found
  sourceRoot = "${src.name}";

  # Use the Cargo.lock from our package directory (at repo root)
  postUnpack = ''
    cp "${./Cargo.lock}" "$sourceRoot/Cargo.lock"
  '';

  # Now we can use the workspace Cargo.lock, but we only build the LSP tool
  buildAndTestSubdir = "crates/tools/src/LSP";

  cargoHash = "sha256-7pA0aQ2Kjnxg+8N477bCE9emzU++LVLHLVVbMEKsqWQ=";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  doCheck = false;

  meta = {
    description = "KCL Language Server - built from main branch with vendored Cargo.lock";
    homepage = "https://www.kcl-lang.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "kcl-language-server";
  };
}
